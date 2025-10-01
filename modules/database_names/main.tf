module "databases" {
  source      = "./dbnames"
  instance_id = var.rds_instance_id
  owner       = "canalisuser"
}


