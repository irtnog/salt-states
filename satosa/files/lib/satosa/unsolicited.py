import satosa.micro_services.base
from satosa.logging_util import satosa_logging
from satosa.response import Redirect
from satosa.exception import SATOSAError

import logging
import random
import string
from datetime import datetime
from saml2.s_utils import deflate_and_base64_encode
from urllib.parse import urlencode

logger = logging.getLogger(__name__)

class UnsolicitedFrontendError(SATOSAError):
    pass

class UnsolicitedFrontend(satosa.frontends.base.FrontendModule):
    """
    SATOSA frontend that implements IdP-initiated SSO.
    """
    logprefix = "UNSOLICITED:"

    def __init__(self, auth_req_callback_func, internal_attributes, config, base_url, name):
        super().__init__(auth_req_callback_func, internal_attributes, base_url, name)
        self.config = config
        if 'proxy_sso_redirect_url' not in self.config:
            msg = "proxy SSO redirect URL not configured"
            satosa_logging(logger, logging.ERROR, msg, None)
            raise UnsolicitedFrontendError(msg)

    def handle_authn_response(self, context, internal_resp, extra_id_token_claims=None):
        """
        See super class method satosa.frontends.base.FrontendModule#handle_authn_response
        :type context: satosa.context.Context
        :type internal_response: satosa.internal_data.InternalResponse
        :rtype oic.utils.http_util.Response
        """
        raise NotImplementedError()

    def handle_backend_error(self, exception):
        """
        See super class satosa.frontends.base.FrontendModule
        :type exception: satosa.exception.SATOSAError
        :rtype: oic.utils.http_util.Response
        """
        raise NotImplementedError()

    def register_endpoints(self, backend_names):
        """
        See super class satosa.frontends.base.FrontendModule
        :type backend_names: list[str]
        :rtype: list[(str, ((satosa.context.Context, Any) -> satosa.response.Response, Any))]
        :raise ValueError: if more than one backend is configured
        """
        url_map = [("^{}".format(self.name), self.unsolicited_endpoint)]
        return url_map

    def unsolicited_endpoint(self, context):
        """
        """
        logprefix = UnsolicitedFrontend.logprefix

        if 'providerID' not in context.request:
            msg = "providerID (SP entityID) not specified"
            satosa_logging(logger, logging.ERROR, msg, context.state)
            raise UnsolicitedFrontendError(msg)
        msg = "{} initiating SAML authentication flow for SP {}".format(logprefix, context.request['providerID'])
        satosa_logging(logger, logging.DEBUG, msg, context.state)

        authnrequest = f"""
<samlp:AuthnRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
                    xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
                    ID="_{"".join(random.choice(string.ascii_letters+"0123456789") for i in range(64))}"
                    Version="2.0"
                    IssueInstant="{datetime.now().replace(microsecond=0).isoformat() + 'Z'}"
                    AssertionConsumerServiceIndex="0">
    <saml:Issuer>{context.request['providerID']}</saml:Issuer>
    <samlp:NameIDPolicy AllowCreate="true"/>
</samlp:AuthnRequest>
"""
        msg = "{} generated SAML AuthnRequest {}".format(logprefix, authnrequest)
        satosa_logging(logger, logging.DEBUG, msg, context.state)

        url = f"""{self.config['proxy_sso_redirect_url']}?{urlencode({'SAMLRequest': deflate_and_base64_encode(authnrequest)})}"""
        if 'target' in context.request:
            msg = "{} setting RelayState to {}".format(logprefix, context.request['target'])
            satosa_logging(logger, logging.DEBUG, msg, context.state)
            url += f"""&{urlencode({'RelayState': context.request['target']})}"""
        msg = "{} generated HTTP Redirect URL {}".format(logprefix, url)
        satosa_logging(logger, logging.DEBUG, msg, context.state)

        return Redirect(url)
