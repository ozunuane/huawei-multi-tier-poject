
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.64.3" # Use a different version here
    }

    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}


provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

#     google-beta = {
#       source = "hashicorp/google-beta"
#     }
#     helm = {
#       source  = "hashicorp/helm"
#       version = ">=2.2.0"
#     }
#     acme = {
#       source  = "vancluever/acme"
#       version = "~> 2.0"
#     }
#     tls      = "~> 3.1.0"
#     random   = "~> 3.1.0"
#     null     = "~> 3.1.0"
#     template = "~> 2.2.0"
#     external = "~> 2.2.0"
#     http     = "~> 2.1.0"
#     local    = "~> 2.1.0"
#   }

