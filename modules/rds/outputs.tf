output "pg_db_id" {
  value = huaweicloud_rds_instance.instance.id
}

output "pg_db_passwd" {
  value     = random_string.postgres_password.result
  sensitive = true
}

output "pg_db_status" {
  value = huaweicloud_rds_instance.instance.status
}