#  Using Terraform to Set Response Headers (Transform Rules)
# Terraform supports Cloudflare Transform Rules, which allow you to modify HTTP response headers.


# resource "cloudflare_ruleset" "security_headers" {
#   zone_id = var.cloudflare_zone_id
#   name    = "Security Headers"
#   kind    = "zone"
#   phase   = "http_response_headers_transform"

#   rules {
#     action      = "set_response_headers"
#     description = "Add security headers"
#     expression  = "true"

#     action_parameters {
#       headers {
#         name  = "Strict-Transport-Security"
#         value = "max-age=31536000; includeSubDomains"
#       }

#       headers {
#         name  = "Content-Security-Policy"
#         value = " default-src 'self'; style-src 'self' 'unsafe-inline';'"
#       }

#       headers {
#         name  = "X-Frame-Options"
#         value = "SAMEORIGIN"
#       }

#       headers {
#         name  = "X-Content-Type-Options"
#         value = "nosniff"
#       }

#       headers {
#         name  = "Referrer-Policy"
#         value = "strict-origin-when-cross-origin"
#       }

#       headers {
#         name  = "Permissions-Policy"
#         value = "geolocation=(), microphone=()"
#       }
#     }
#   }
# }


# variable "cloudflare_api_token" {
#   description = "API token for Cloudflare"
#   type        = string
# }

# variable "cloudflare_zone_id" {
#   description = "Zone ID for Cloudflare"
#   type        = string
# }