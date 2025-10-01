output "custom_subnet_id" {
  value = values(huaweicloud_vpc_subnet.subnet_with_tags)[*].id
}


