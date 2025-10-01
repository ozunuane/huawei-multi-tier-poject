
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.64.3"
    }
  }
}


data "huaweicloud_vpcs" "vpc" {
  name = var.vpc_name
}


locals {
  current_region = "af-south-1"
}

locals {
  az_letter = ["a", "b", "c"]
  network_flat = flatten([
    for service, network in var.networks : [
      for app, address in network["subnets"] : [
        {
          az        = "${local.current_region}${local.az_letter[app]}"
          ip        = address
          id        = service
          is_public = network["is_public"]
        }
      ]
    ]
  ])
}


resource "huaweicloud_vpc_subnet" "subnet_with_tags" {
  for_each          = { for net_info in local.network_flat : "${net_info.ip}:${net_info.id}" => net_info }
  name              = "${var.name}-subnet"
  cidr              = each.value.ip
  gateway_ip        = cidrhost(each.value.ip, 1) # Fix gateway_ip calculation
  vpc_id            = var.vpc_id
  availability_zone = each.value.az

  tags = {
    resource = "custom-subnet"
  }
}
