
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.36.0"
    }
  }
}




resource "huaweicloud_cce_cluster" "mycce" {
  name                   = var.name
  flavor_id              = var.flavor_id
  vpc_id                 = var.vpc_id
  subnet_id              = var.subnet_id[0]
  container_network_type = "overlay_l2"
  eip                    = var.demo_eip_address // If you choose not to use EIP, skip this line.
  lifecycle {
    ignore_changes = [eip, subnet_id, ]
  }
}
