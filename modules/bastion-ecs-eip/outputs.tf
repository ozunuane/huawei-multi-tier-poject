output "bastion_id" {
  value = huaweicloud_compute_instance.myinstance.id
}

output "bastion_eip" {
  value = huaweicloud_vpc_eip.myeip.address
}

output "bastion_user" {
  value = huaweicloud_compute_instance.myinstance.user_id
}
output "bastion_key_pair" {
  value = huaweicloud_compute_instance.myinstance.key_pair
}


output "bastion_ssh" {
  value = huaweicloud_kps_keypair.keypair.private_key
}

output "bastion_pass" {
  value = huaweicloud_compute_instance.myinstance.admin_pass
}

output "generated_password" {
  value = random_string.key_name.result
}
