terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.64.3"
    }
  }
}

resource "huaweicloud_cce_namespace" "test" {
  for_each   = { for idx, name in var.namespace_names : idx => name }
  cluster_id = var.cluster_id
  name       = each.value
}

