backend "file" {
  path = "/var/db/vault"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_cert_file = "/usr/local/etc/vault.crt"
  tls_key_file = "/usr/local/etc/vault.key"
}
