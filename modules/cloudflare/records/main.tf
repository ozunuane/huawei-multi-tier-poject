terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.0.0" # Use the version you need
    }
  }
}


resource "cloudflare_record" "records" {
  for_each = { for domain in var.domains : domain => domain }
  zone_id  = var.cloudflare_zone_id
  name     = each.key
  value    = var.ip_address
  type     = "A"
  ttl      = 1
  proxied  = true
}