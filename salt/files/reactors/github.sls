#!py
#### STATES/SALT/REACTOR/GITHUB.SLS --- Salt Reactor formula for GitHub webhooks

### Copyright (C) 2015 Matthew X. Economou <xenophon@irtnog.org>
### Copyright (C) 2014, 2015 Carlos Jenkins <carlos@jenkins.co.cr>
###
### Licensed under the Apache License, Version 2.0 (the "License");
### you may not use this file except in compliance with the License.
### You may obtain a copy of the License at
###
###     http://www.apache.org/licenses/LICENSE-2.0
###
### Unless required by applicable law or agreed to in writing,
### software distributed under the License is distributed on an "AS
### IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
### express or implied.  See the License for the specific language
### governing permissions and limitations under the License.

### For more information about the format of this file, see
### http://docs.saltstack.com/en/latest/topics/reactor/,
### http://docs.saltstack.com/en/latest/ref/netapi/all/salt.netapi.rest_cherrypy.html#salt.netapi.rest_cherrypy.app.Webhook,
### http://docs.saltstack.com/en/latest/ref/renderers/all/salt.renderers.py.html,
### https://developer.github.com/webhooks/,
### https://developer.github.com/v3/repos/hooks/,
### https://github.com/github/github-services/tree/master/lib/service/events,
### and http://drunkenpython.org/dispatcher-pattern-safety.html.  For
### more information about change management procedures, see TODO.
### The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL
### NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL"
### in this document are to be interpreted as described in RFC 2119,
### http://www.rfc-editor.org/rfc/rfc2119.txt.  The keywords "DANGER",
### "WARNING", and "CAUTION" in this document are to be interpreted as
### described in OSHA 1910.145,
### https://www.osha.gov/pls/oshaweb/owadisp.show_document?p_table=standards&p_id=9794.

## required by the webhook processor
from ipaddress import ip_address, ip_network
import requests
import hmac
import hashlib
from sys import hexversion

## required by the hook dispatch methods
from re import match

class GitHubReactions(object):
    def __init__(self, payload, event, repo, branch):
        self.payload = payload
        self.event = event
        self.repo = repo
        self.branch = branch

    def push(self):
        if match("-formula$", self.repo):
            return { 'salt_master_{repo}_update'.format(repo=self.repo):
                     { 'local.state.sls':
                       [ { 'tgt': 'I@role:salt-master' },
                         { 'expr_form': 'compound' },
                         { 'arg': [ 'salt.formulas' ] },
                         { 'kwarg':
                           [ { 'saltenv': 'production' },
                             { 'pillar':
                               { 'salt_formulas':
                                 { 'git_opts':
                                   { 'default':
                                     { 'baseurl': 'git@github.com:irtnog',
                                       'basedir': '/usr/local/etc/salt/formulas',
                                       'update': True } },
                                   'basedir_opts':
                                   { 'makedirs': True,
                                     'user': 'root',
                                     'group': 'wheel',
                                     'mode': 755 },
                                   'list':
                                   { 'development': [ self.repo ],
                                     'testing': [ self.repo ],
                                     'staging': [ self.repo ],
                                     'production': [ self.repo ] } } } } ] } ] } }
        elif self.repo == 'salt-states':
            return { 'salt_master_fileserver_update':
                     { 'local.cmd.run':
                       [ { 'tgt': 'I@role:salt-master' },
                         { 'expr_form': 'compound' },
                         { 'arg': [ 'salt-run fileserver.update' ] } ] } }
        else:
            return self.no_op()

    ## This function... it does nothing!
    def no_op(self):
        return {}

def run():
    '''
    Webhook processor
    '''

    ## Only process calls originating from GitHub, based on the code
    ## located at:
    ## https://github.com/carlos-jenkins/python-github-webhooks/blob/29fd83971cb5bf4a0e7705a5c31661d7c80fc03c/webhooks.py#L55.
    src_ip = ip_address(u'{}'.format(data['headers']['Remote-Addr']))
    whitelist = requests.get('https://api.github.com/meta').json()['hooks']
    for valid_ip in whitelist:
        break if src_ip in ip_network(valid_ip)
    else:
        return                  # FIXME: return/log error?

    ## Check the signature of the payload using the shared secret key
    ## (if one is set), based on the code located at
    ## https://github.com/carlos-jenkins/python-github-webhooks/blob/29fd83971cb5bf4a0e7705a5c31661d7c80fc03c/webhooks.py#L68.
    ## WARNING: This only works if the request body is JSON (the
    ## default).  rest_cherrypy will not put the raw (unmodified)
    ## request body into `data['body']` if it receives URL-encoded
    ## form data, which breaks signature verification.
    secret = {{ salt['pillar.get']('salt:github:hook_secret', "None") }}
    if secret:

        ## Read out the signature and the name of the cryptographic
        ## hash function used to generate it.
        hashfunc, signature = data['headers']['X-Hub-Signature'].split('=')

        ## Compute the HMAC of the raw POST data using our copy of the
        ## secret key and the algorithm specified by GitHub in its
        ## signature.
        mac = hmac.new(str(secret), msg=data['body'], digestmod=getattr(hashlib, hashfunc))

        ## Python versions 2.7.7 and later have hmac.compare_digest(),
        ## which provides protection against timing attacks.
        if hexversion >= 0x020707F0:
            if not hmac.compare_digest(str(mac.hexdigest()), str(signature)):
                return          # FIXME: return/log error?
        else:
            if not str(mac.hexdigest()) == str(signature):
                return          # FIXME: return/log error?

    ## Save the event ID and payload in convenience variables.
    event = data['headers']['X-GitHub-Event'].
    payload = data['post']['payload']

    ## Determine the repository; NOTE: some legacy event types do not
    ## have an associated repository.
    repo = None
    if 'repository' in payload:
        repo = payload['repository']['name']

    ## Determine the branch (only for certain event types).
    branch = None
    try:
        ## Case 1: events with a ref_type of 'branch' (create and
        ## delete events)
        if 'ref_type' in payload:
            if payload['ref_type'] == 'branch':
                branch = payload['ref']

        ## Case 2: pull_request and pull_request_review_comment events
        elif 'pull_request' in payload:
            ## NOTE: *target* branch for the pull request, not source
            branch = payload['pull_request']['base']['ref']

        ## Case 3: push events, which provide a full Git ref but do
        ## not set a ref_type
        elif event == 'push':
            branch = payload['ref'].split('/')[2] # FIXME: possible bug here when branches have '/' in their names?

    ## If the payload is not structured the way we expect, leave the
    ## branch name blank.
    except KeyError:
        pass

    ## The additional convenience variables.
    event_repo_branch = "{event}_{repo}_{branch}".format(event=event, repo=repo, branch=branch)
    event_repo = "{event}_{repo}".format(event=event, repo=repo)

    ## Execute methods of GitHubReactions in the following order:
    ##   - {event}_{repo}_{branch}
    ##   - {event}_{repo}
    ##   - {event}
    ##   - all
    retval = {}
    reactions = GitHubReactions(payload, event, repo, branch)
    retval.update(getattr(reactions, event_repo_branch, 'no_op')())
    retval.update(getattr(reactions, event_repo, 'no_op')())
    retval.update(getattr(reactions, event, 'no_op')())
    retval.update(getattr(reactions, 'all', 'no_op')())
    return retval

#### Local Variables:
#### mode: python
#### End:

#### STATES/SALT/REACTOR/GITHUB.SLS ends here.
