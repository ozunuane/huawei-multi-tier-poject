###################################################################
################## create cloudflare certificate ##################
###################################################################

# ##############################################################################
# ##################### orionx.COM DOMAIN ######################################
# ##############################################################################
provider "cloudflare" {
  api_token = var.cloudflare_api_token
  alias     = "certs"
}

resource "tls_private_key" "cert" {
  algorithm = "RSA"
}

resource "tls_cert_request" "cert" {
  count           = terraform.workspace == "dev" ? 1 : 0
  private_key_pem = tls_private_key.cert.private_key_pem
  subject {
    common_name  = "orionx"
    organization = "orionx"
  }
}

# # ###################################################################
# # ############### server certificate 9JAPAY #########################
# # ###################################################################
# resource "cloudflare_origin_ca_certificate" "cert" {
#   count              = terraform.workspace == "dev" ? 1 : 0
#   csr                = tls_cert_request.cert.cert_request_pem
#   hostnames          = ["*.${var.cloud_flare_cert_hostnames_prefix}.orionx.com"]
#   request_type       = "origin-rsa"
#   requested_validity = 5475
# }

# ##################################################################
# ############# Root origin certificate 9JAPAY #####################
# ##################################################################
data "cloudflare_origin_ca_root_certificate" "cert" {
  count     = terraform.workspace == "dev" ? 1 : 0
  algorithm = tls_private_key.cert.algorithm
}

resource "cloudflare_origin_ca_certificate" "cert" {
  count              = terraform.workspace == "dev" ? 1 : 0
  csr                = tls_cert_request.cert[count.index].cert_request_pem
  hostnames          = ["*.${var.cloud_flare_cert_hostnames_prefix}.inorionx.com"]
  request_type       = "origin-rsa"
  requested_validity = 5475
}

resource "huaweicloud_lb_certificate" "certificate_1" {
  count       = terraform.workspace == "dev" ? 1 : 0
  name        = "${var.env}-orionx-domain"
  description = "terraform dev orionx certificate"
  domain      = "*.${var.cloud_flare_cert_hostnames_prefix}.inorionx.com"
  private_key = tls_private_key.cert.private_key_pem
  certificate = cloudflare_origin_ca_certificate.cert[count.index].certificate

}

resource "huaweicloud_lb_certificate" "certificate_2" {
  count       = terraform.workspace == "dev" ? 1 : 0
  name        = "orionx-domain"
  description = "terraform dev orionx certificate"
  domain      = "*.inorionx.com"
  private_key = tls_private_key.cert.private_key_pem
  certificate = cloudflare_origin_ca_certificate.cert[count.index].certificate

}
