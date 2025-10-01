terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "1.64.4"
    }
  }
}

resource "random_string" "redis_password" {
  length  = 16
  special = false
  numeric = true
  lower   = true
  upper   = true
}

resource "huaweicloud_csms_secret" "redis_password" {
  name        = "${var.name}-redis-pass"
  secret_text = random_string.redis_password.result

}


data "huaweicloud_dcs_flavors" "single_flavors" {
  cache_mode = "single"
  capacity   = 2
  name       = "redis.single.xu1.large.2"
}


resource "huaweicloud_dcs_instance" "redis_instance" {
  name               = "${var.name}-redis-${var.env}"
  engine             = "Redis"
  engine_version     = "6.0"
  capacity           = data.huaweicloud_dcs_flavors.single_flavors.capacity
  flavor             = data.huaweicloud_dcs_flavors.single_flavors.flavors[0].name
  availability_zones = [var.availability_zones]
  password           = random_string.redis_password.result
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_id
  whitelists {
    group_name = "${var.name}-${var.env}-group"
    ip_address = var.whitelisted_ips
  }
}