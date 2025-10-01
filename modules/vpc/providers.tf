terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.64.3" # Update the version as needed
    }
  }
}


provider "huaweicloud" {
  region = var.region

}