output "id" {
  description = "The resource ID in UUID format"
  value       = huaweicloud_vpc_eip.main.id
}

output "address" {
  description = "The IPv4 address of the EIP"
  value       = huaweicloud_vpc_eip.main.address
}

output "ipv6_address" {
  description = "The IPv6 address of the EIP"
  value       = huaweicloud_vpc_eip.main.ipv6_address
}

output "private_ip" {
  description = "The private IP address bound to the EIP"
  value       = huaweicloud_vpc_eip.main.private_ip
}

output "port_id" {
  description = "The port ID which the EIP associated with"
  value       = huaweicloud_vpc_eip.main.port_id
}

output "status" {
  description = "The status of EIP"
  value       = huaweicloud_vpc_eip.main.status
}

output "bandwidth_name" {
  description = "The private IP address bound to the EIP"
  value       = huaweicloud_vpc_eip.main.bandwidth[0]
}