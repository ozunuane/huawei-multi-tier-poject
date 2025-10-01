output "ecs_instance_id" {
  value = huaweicloud_compute_instance.myinstance.id
}

output "remote_address_group_id" {
  value = huaweicloud_vpc_address_group.ecs_ip.id
}


