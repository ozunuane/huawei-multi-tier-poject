terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "1.64.4"
    }
  }
}

resource "huaweicloud_rds_pg_database" "test" {
  for_each    = toset(local.dbnames)
  instance_id = var.instance_id
  name        = each.value
  owner       = var.owner
  # lifecycle {
  #   ignore_changes = all
  # }
}


# resource "null_resource" "check_db_exists" {
#   for_each = toset(local.dbnames)

#   provisioner "local-exec" {
#     command = <<-EOT
#       for i in {1..10}; do
#         if psql -h ${huaweicloud_rds_pg_database.test[each.key].address} -U ${var.owner} -d ${each.value} -c "SELECT 1" > /dev/null 2>&1; then
#           echo "Database ${each.value} is available."
#           exit 0
#         else
#           echo "Waiting for database ${each.value} to be available..."
#           sleep 30
#         fi
#       done
#       echo "Database ${each.value} not available after waiting."
#       exit 1
#     EOT
#   }

#   depends_on = [huaweicloud_rds_pg_database.test]
# }

resource "huaweicloud_rds_pg_plugin" "test" {
  for_each      = toset(local.dbnames)
  instance_id   = var.instance_id
  database_name = each.value
  name          = "uuid-ossp"

  # depends_on = [
  #   huaweicloud_rds_pg_database.test,
  #   null_resource.check_db_exists
  # ]
  # lifecycle {
  #   ignore_changes = all
  # }
}
