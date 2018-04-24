import satosa.micro_services.base
from satosa.logging_util import satosa_logging
from satosa.exception import SATOSAError

import copy
import logging
import re
import urllib

logger = logging.getLogger(__name__)

class AwsAttributeReleaseError(SATOSAError):
    pass

class AwsAttributeRelease(satosa.micro_services.base.ResponseMicroService):
    default_aws_entity_ids = [
        'urn:amazon:webservices',
        'urn:amazon:webservices:govcloud',
    ]

    default_sp_config = {
        'role_source': 'ismemberof',
        'role_source_filter': '^[A-Za-z0-9+=,.@_-]+$',
        'saml_provider_name': 'SATOSA',
    }

    def __init__(self, config, *args, **kwargs):
        super().__init__(*args, **kwargs)

        ## TODO: validate account IDs
        aws_accounts = [
            "{}".format(key) for key in config.keys()
            if key not in [
                    'aws_entity_ids',
            ]
        ]
        if not aws_accounts:
            msg = "No AWS accounts configured"
            satosa_logging(logger, logging.ERROR, msg, None)
            raise AwsAttributeReleaseError(msg)
        msg = "Configured for the following AWS accounts: {}".format(', '.join(aws_accounts))
        satosa_logging(logger, logging.DEBUG, msg, None)

        aws_entity_ids = AwsAttributeRelease.default_aws_entity_ids
        if 'aws_entity_ids' in config:
            if not config['aws_entity_ids']:
                msg = "No AWS services configured"
                satosa_logging(logger, logging.ERROR, msg, None)
                raise AwsAttributeReleaseError(msg)
            aws_entity_ids = config['aws_entity_ids']

        ## This is a dictionary of dictionaries, first keyed by
        ## service (entity ID) and then by AWS account.  The value of
        ## each account/service combo is the merged configuration
        ## (built-in defaults, configured defaults, and
        ## service-specific settings).
        self.config = { service: {} for service in aws_entity_ids }

        ## For each service/account combination, merge the built-in
        ## defaults with the configured defaults and the
        ## service-specific configs (in that order), then sanity-check
        ## the resulting configuration.
        for account in aws_accounts:
            if not isinstance(config[account], dict):
                msg = "Configuration value for {} must be a dictionary"
                satosa_logging(logger, logging.ERROR, msg, None)
                raise AwsAttributeReleaseError(msg)

            for service in aws_entity_ids:
                self.config[service][account] = copy.deepcopy(AwsAttributeRelease.default_sp_config)
                if 'default' in config[account]:
                    self.config[service][account].update(config[account]['default'])
                if service in config[account]:
                    self.config[service][account].update(config[account][service])

                if not isinstance(self.config[service][account]['role_source'], str):
                    msg = "Invalid role source attribute for AWS account {}, entity ID {} (must be a string)".format(account, service)
                    satosa_logging(logger, logging.ERROR, msg, None)
                    raise AwsAttributeReleaseError(msg)

                ## TODO: include the error message
                try:
                    regexp = re.compile(self.config[service][account]['role_source_filter'])
                    self.config[service][account]['role_source_regexp'] = regexp
                except re.error as err:
                    msg = "Invalid regular expression in the role source filter for AWS account {}, entity ID {}".format(account, service)
                    satosa_logging(logger, logging.ERROR, msg, None)
                    raise AwsAttributeReleaseError(msg)

                if not isinstance(self.config[service][account]['saml_provider_name'], str):
                    msg = "Invalid IAM identity provider ID (must be a string)"
                    satosa_logging(logger, logging.ERROR, msg, None)
                    raise AwsAttributeReleaseError(msg)

                if not self.config[service][account]['saml_provider_name']:
                    msg = "Invalid IAM identity provider ID (must not be an empty string)"
                    satosa_logging(logger, logging.ERROR, msg, None)
                    raise AwsAttributeReleaseError(msg)

                if len(self.config[service][account]['saml_provider_name']) > 128:
                    msg = "Invalid IAM identity provider ID (must not be greater than 128 characters)"
                    satosa_logging(logger, logging.ERROR, msg, None)
                    raise AwsAttributeReleaseError(msg)

                if not re.match('[A-Za-z0-9._-]+', self.config[service][account]['saml_provider_name']):
                    msg = "Invalid IAM identity provider ID (contains invalid characters)"
                    satosa_logging(logger, logging.ERROR, msg, None)
                    raise AwsAttributeReleaseError(msg)

        msg = "AWS Attribute Release microservice initialized"
        satosa_logging(logger, logging.INFO, msg, None)

    def process(self, context, data):
        """
        Default interface for microservices. Process the input data for
        the input context.
        """
        self.context = context

        ## Find the entity ID for the SP that initiated the flow.
        try:
            sp_entity_id = context.state.state_dict['SATOSA_BASE']['requester']
        except KeyError as err:
            msg = "Unable to determine the entityID for the SP requester"
            satosa_logging(logger, logging.ERROR, msg, context.state)
            return super().process(context, data)

        ## Get the configuration for the SP.
        if sp_entity_id not in self.config:
            msg = "Ignoring SP {}".format(sp_entity_id)
            satosa_logging(logger, logging.INFO, msg, context.state)
            return super().process(context, data)
        sp_config = self.config[sp_entity_id]
        msg = "Found SP {}".format(sp_entity_id)
        satosa_logging(logger, logging.DEBUG, msg, context.state)

        ## Assert the Role.
        msg = "sp_config = {}".format(sp_config)
        satosa_logging(logger, logging.DEBUG, msg, context.state)
        data.attributes['aws_role_entitlement'] = [
            "arn:aws:iam::{0}:role/{1},arn:aws:iam::{0}:saml-provider/{2}".format(
                account,
                role,
                sp_config[account]['saml_provider_name']
            )
            for account in sp_config.keys()
            for role in data.attributes[sp_config[account]['role_source']]
            if sp_config[account]['role_source_regexp'].match(role)
        ]
        msg = "Returning {}".format(data.attributes)
        satosa_logging(logger, logging.DEBUG, msg, context.state)

        return super().process(context, data)
