# ### Cluster Locals ######
locals {
  cluster_name    = module.k8s_cluster.cluster_name
  cluster_cidr    = module.k8s_cluster.container_network_cidr
  bastion_ip      = module.bastion.bastion_eip
  kube_config_raw = module.k8s_cluster.kube_config_raw
}

