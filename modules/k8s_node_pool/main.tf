terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.64.3"
    }
  }
}





resource "huaweicloud_cce_node_pool" "node_pool" {
  # count                    = length(var.taints)
  cluster_id         = var.cluster_id
  name               = var.node_pool_name
  os                 = "EulerOS 2.9"
  initial_node_count = 2
  flavor_id          = var.nodepool_flavor_id
  availability_zone  = var.availability_zone
  key_pair           = var.key_pair
  scall_enable       = true
  min_node_count     = var.min_node_count
  max_node_count     = var.max_node_count

  scale_down_cooldown_time = 100
  priority                 = 1
  type                     = "vm"

  root_volume {
    size       = 40
    volumetype = "SAS"
  }
  data_volumes {
    size       = 100
    volumetype = "SAS"
  }

  # taints {
  #   key    = var.taints[count.index].key
  #   value  = var.taints[count.index].value
  #   effect = var.taints[count.index].effect
  # }


  lifecycle {
    ignore_changes = [
      password, subnet_id, os
    ]
  }


}