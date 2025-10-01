output "cluster_id" {
  value = huaweicloud_cce_cluster.mycce.id
}

output "cluster_name" {
  value = huaweicloud_cce_cluster.mycce.name
}

output "container_network_cidr" {
  value = huaweicloud_cce_cluster.mycce.container_network_cidr
}
# output "eni_subnet_id" {
#   value = huaweicloud_vpc_subnet.eni.ipv4_subnet_id
# }

output "kube_config_raw" {
  value = huaweicloud_cce_cluster.mycce.kube_config_raw
}