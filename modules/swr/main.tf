
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.64.3"
    }
  }
}




# resource "huaweicloud_swr_image_auto_sync" "this" {
#   organization        = huaweicloud_swr_organization.this.name
#   repository          = huaweicloud_swr_repository.this.name
#   target_region       = var.region
#   target_organization = huaweicloud_swr_organization.this.name
# }


resource "huaweicloud_swr_image_permissions" "test" {
  organization = var.organization_name
  region       = var.region
  repository   = huaweicloud_swr_repository.this.name
  users {
    user_name  = var.user_name
    user_id    = var.user_id
    permission = "Manage"
  }
  lifecycle {
    ignore_changes = [users]
  }
  depends_on = [huaweicloud_swr_organization.this, huaweicloud_swr_repository.this]
}



resource "huaweicloud_swr_image_retention_policy" "this" {
  organization = huaweicloud_swr_organization.this.name
  repository   = var.repository_name
  type         = "date_rule"
  number       = 20

  tag_selectors {
    kind    = "label"
    pattern = "abc"
  }

  tag_selectors {
    kind    = "regexp"
    pattern = "abc*"
  }
}


resource "huaweicloud_swr_organization" "this" {
  name = var.organization_name
}


resource "huaweicloud_swr_repository" "this" {
  organization = huaweicloud_swr_organization.this.name
  region       = var.region
  name         = var.repository_name
  description  = "development repository"
  category     = "linux"
}

