
resource "tls_private_key" "alb_tls" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "alb_tls" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.alb_tls.private_key_pem

  subject {
    common_name  = "*.elb.amazonaws.com"
    organization = "Rearc"
  }

  validity_period_hours = 730

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "alb_cert" {
  private_key      = tls_private_key.alb_tls.private_key_pem
  certificate_body = tls_self_signed_cert.alb_tls.cert_pem
}