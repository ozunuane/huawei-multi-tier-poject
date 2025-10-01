terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "1.64.4"
    }
  }
}

resource "random_string" "postgres_password" {
  length  = 16
  special = false
  numeric = true
  lower   = true
  upper   = true
}

resource "huaweicloud_csms_secret" "postgres_password" {
  name        = "${var.name}-pg-pass"
  secret_text = random_string.postgres_password.result

}

resource "huaweicloud_rds_instance" "instance" {
  name              = "${var.name}-rds-instance"
  flavor            = var.flavor
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  security_group_id = var.secgroup_id
  availability_zone = [var.availability_zone]

  db {
    type     = "PostgreSQL"
    version  = "16"
    password = random_string.postgres_password.result
  }

  volume {
    type = "CLOUDSSD"
    size = var.db_zize
  }

  backup_strategy {
    start_time = "08:00-09:00"
    keep_days  = 1
  }

  parameters {
    name  = "div_precision_increment"
    value = "12"
  }

  parameters {
    name  = "connect_timeout"
    value = "15"
  }


}