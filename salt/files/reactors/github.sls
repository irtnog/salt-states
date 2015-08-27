#### GITHUB.SLS --- Salt Reactor formula PoC for GitHub webhook events

github_test:
  local.test.ping:
    - tgt: '*'

#### GITHUB.SLS ends here.
