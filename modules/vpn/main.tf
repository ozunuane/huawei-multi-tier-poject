terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.64.3"

    }
  }
}


data "huaweicloud_availability_zones" "this" {
  region = "af-south-1"
}

resource "huaweicloud_vpn_gateway" "this" {
  name           = var.name
  vpc_id         = var.vpc_id
  local_subnets  = var.local_subnets
  connect_subnet = var.connect_subnet
  availability_zones = [
    data.huaweicloud_availability_zones.this.names[0],
    data.huaweicloud_availability_zones.this.names[1]
  ]
  eip1 {
    bandwidth_name = var.bandwidth_name1
    type           = "5_bgp"
    bandwidth_size = 20
    charge_mode    = "traffic"
  }

  eip2 {
    bandwidth_name = var.bandwidth_name2
    type           = "5_bgp"
    bandwidth_size = 20
    charge_mode    = "traffic"
  }

}