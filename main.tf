########## VPC ######################

locals {
  private_cidr = cidrsubnet(var.cidr, 2, 0)
  public_cidr  = cidrsubnet(var.cidr, 2, 1)
}
data "huaweicloud_availability_zones" "name" {
}


####### EIP -- NAT #########
module "nat_eip" {
  source       = "./modules/eip"
  name         = var.name
  name_postfix = "gw-snat"
  env          = var.env
}

module "vpc" {
  source             = "./modules/vpc"
  name               = var.vpc_name
  region             = var.region
  availability_zones = slice(data.huaweicloud_availability_zones.name.names, 0, 2)
  cidr               = var.cidr
  vpn_cidr           = var.vpn_cidr
  vpn_inbound_cidr   = var.vpn_inbound_cidr
  subnets = {
    public = [
      for num in range(0, 3) : cidrsubnet(local.public_cidr, 2, num)
    ]
    private = [
      for num in range(0, 3) : cidrsubnet(local.private_cidr, 2, num)
    ]
  }
  private_to_internet = false
  # primary_dns         = "100.125.1.250"
  nat_snat_floating_ip_ids = [
    module.nat_eip.id
  ]
  tags = var.tags
}




# ################ Kubernetes Cluster Setup #################
# ######## Kubernetes cluster security group  ###########
module "k8_ms_sg" {
  source      = "./modules/security-group"
  name        = "${var.name}-${var.k8_secgroup_name}"
  description = "Canalis test-SG description"
  rules       = var.k8s_sg_rules["rules"]
  vpc_cidr    = var.cidr
}



###### allow bastion into k8_cluster #### 
resource "huaweicloud_networking_secgroup_rule" "Allow_bastion_into_clusters" {
  security_group_id = module.k8_ms_sg.this_security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  action            = "allow"
  remote_group_id   = module.bastion_sg.this_security_group_id
}






####################################################
#### ELastic Ip for cluster ######
module "k8s_cluster_eip" {
  source       = "./modules/eip"
  name         = var.name
  name_postfix = "gw-snat"
  env          = var.env
}


########  k8s  CLUSTER  #########
module "k8s_cluster" {
  source              = "./modules/cluster"
  name                = var.cluster_name
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.private_subnets_ids
  private_subnets_ids = module.vpc.private_subnets_ids
  security_group_id   = module.k8_ms_sg.this_security_group_id
  flavor_id           = var.cce_flavor_id
  cluster_name        = "${var.cluster_name}-${var.env}"
  demo_eip_address    = module.k8s_cluster_eip.address

}


########  k8s CLUSTER NAME-SPACES #########
module "namespace_cluster" {
  source          = "./modules/namespace"
  cluster_id      = module.k8s_cluster.cluster_id
  namespace_names = var.namespace_names
}

######## nodepool keypair #########
module "nodepool_keypair" {
  source = "./modules/keypair"
  name   = var.name
  env    = var.env

}



# ###################################################################################
# ######## NODEPOOL #####################
# ##################   NODE-POOLS ########################
module "node_pool" {
  source            = "./modules/k8s_node_pool"
  availability_zone = data.huaweicloud_availability_zones.name.names[1]
  cluster_id        = module.k8s_cluster.cluster_id
  key_pair          = module.nodepool_keypair.name
  max_node_count    = var.max_node_count
  node_pool_name    = var.node_pool_name
  min_node_count    = var.min_node_count
  # taints             = var.taints
  security_groups    = [module.k8_ms_sg.this_security_group_id]
  nodepool_flavor_id = var.nodepool_flavor_id
}




# ####################################################################################
# ############# image repo swr ########################

module "canalis_image_repo" {
  source            = "./modules/swr"
  organization_name = var.swr_organization_name
  repository_name   = var.repository_name
  region            = var.region
  user_id           = var.swr_user_id
  user_name         = var.swr_user_name
}


# ################################################################################
# ####### BASTION  #########
# ################################################################################

module "bastion" {
  source            = "./modules/bastion-ecs-eip"
  name              = var.name
  subnet_id         = module.vpc.public_subnets_ids
  secgroup_id       = module.bastion_sg.this_security_group_id
  availability_zone = data.huaweicloud_availability_zones.name.names[1]
  region            = var.region
  cluster_name      = local.cluster_name
  kube_config_raw   = local.kube_config_raw
  user_id           = var.terraform_user_id
  flavor_id         = var.bastion_flavor_id
  env               = var.env
}


module "bastion_sg" {
  source      = "./modules/security-group"
  name        = "${var.name}-${var.env}bastion-backend-sg"
  description = "Canalis Bastion-SG description"
  rules       = var.bastion_sg_rules["rules"]
  vpc_cidr    = var.cidr
}

# ###########################################
# ####### POSTGRESS  #########
# #####################################


module "postgres" {
  source            = "./modules/rds"
  name              = var.name
  env               = var.env
  db_zize           = 100
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.private_subnets_ids[0]
  secgroup_id       = module.bastion_sg.this_security_group_id
  availability_zone = data.huaweicloud_availability_zones.name.names[1]

}

module "databases" {
  source          = "./modules/database_names"
  rds_instance_id = module.postgres.pg_db_id
}

###### allow bastion FROM k8_cluster #### 
resource "huaweicloud_networking_secgroup_rule" "Allow_bastion_from_clusters" {
  security_group_id = module.bastion_sg.this_security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  action            = "allow"
  remote_group_id   = module.k8_ms_sg.this_security_group_id
  description       = "Allow bastion security group into kuberenetes clusters"

}

# ###########################################
# ####### REDIS  #########
# #####################################

module "redis" {
  count              = 0
  source             = "./modules/redis"
  name               = var.name
  env                = var.env
  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.vpc.public_subnets_ids[0]
  availability_zones = data.huaweicloud_availability_zones.name.names[0]
  whitelisted_ips    = var.Redis_whitelisted_ips

}


# #########################################################################
# ###### NIP PROXY MACHINE ##########
# module "nip_proxy_vm" {
#   source            = "./modules/ecs"
#   name              = "${var.name}-nip-proxy"
#   subnet_id         = module.vpc.private_subnets_ids[1]
#   secgroup_id       = module.nip_proxy_vm_sg.this_security_group_id
#   keypair           = var.key_pair
#   availability_zone = data.huaweicloud_availability_zones.name.names[2]
# }


# ##### nip security group #####
# module "proxy_vm_sg" {
#   source      = "./modules/security-group"
#   name        = "${var.name}-nip-proxy-vm-sg"
#   description = "canalis Nip Proxy Server Security Group"
#   rules       = var.nip_sg_rules["rules"]
#   vpc_cidr    = var.cidr
# }

# ###### allow bastion into nip #### 
# resource "huaweicloud_networking_secgroup_rule" "Allow_bastion_into_nip" {
#   security_group_id = module.nip_proxy_vm_sg.this_security_group_id
#   direction         = "ingress"
#   ethertype         = "IPv4"
#   protocol          = "tcp"
#   action            = "allow"
#   remote_group_id   = module.bastion_sg.this_security_group_id
#   description       = "Allow bastion security group into nip access "
# }

# ###### allow clusters into nip #### 
# resource "huaweicloud_networking_secgroup_rule" "Allow_k8s_into_nip" {
#   security_group_id = module.nip_proxy_vm_sg.this_security_group_id
#   direction         = "ingress"
#   ethertype         = "IPv4"
#   protocol          = "tcp"
#   action            = "allow"
#   remote_group_id   = module.k8_ms_sg.this_security_group_id
#   description       = "Allow k8-cluster security group into nip access "

# }


# ############## NIP GRANUALR PROXY FIREWALL RULES  --- ALLOW CBA CONTAINER_CIDR ALONE ###############
# resource "huaweicloud_networking_secgroup_rule" "Allow_http_traffic_from_cba" {
#   security_group_id = module.nip_proxy_vm_sg.this_security_group_id
#   direction         = "ingress"
#   ethertype         = "IPv4"
#   protocol          = "tcp"
#   port_range_min    = 0
#   port_range_max    = 0
#   remote_ip_prefix  = local.cba_cluster_cidr
# }


##### ALLOW SSH FROM OTHER IP'(ADDRESS GROUP) INTO NIP ###########
# resource "huaweicloud_networking_secgroup_rule" "Allow_ssh_traffic_from_bastion" {
#   security_group_id = module.nip_proxy_vm_sg.this_security_group_id
#   direction         = "ingress"
#   ethertype         = "IPv4"
#   protocol          = "tcp"
#   ports             = 22

#   remote_address_group_id = huaweicloud_vpc_address_group.nip_ipaddress_allow.id
# }

# resource "huaweicloud_vpc_address_group" "nip_ipaddress_allow" {
#   name = "${var.name}-nip-alllowed_ip"

#   addresses = var.nip_allowed_ip
# }





# module "redis" {
# #   source  = "./modules/redis"
# #   name =  var.redis_name
# #   subnet_id  = module.vpc.private_subnets_ids[*]
# #   availability_zone = module.vpc.availability_zones[*]
# #   vpc_id = module.vpc.vpc_id
# #   secgroup_id = module.canalis_backend_sg.this_security_group_id
# # }
