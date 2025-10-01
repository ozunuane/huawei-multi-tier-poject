######## VPC VAR #########
cidr     = "100.5.0.0/16"
vpc_name = "afl-controlled"
name     = "afl-controlled"
region   = "af-south-1"




##### ALLOW-OUTBOUND TRAFFIC TO EXTERNAL IP'S FROM PRIVATE-NACL ####
vpn_cidr = [

  #### HABARI TEST ENVIRONMENT LOCAL VPN IP
  "10.83.1.10",
  #### GCP TEST VPN LOCAL VPN IP
  "10.154.0.0/20",
  ### HUAWEI REPOSITORY
  "223.119.40.146",
  "159.138.179.0/24"

]



######## ALLOW-INBOUND TRAFFIC TO VPN TRAFFIC INTO VPC PRIVATE-NACL ########
vpn_inbound_cidr = {

  #### ALLOW gcp into Nip-Proxy VM ###
  "VPN_CIDR_1" = {
    source_cidr      = "10.154.0.0/20",
    destination_cidr = "100.10.19.90"
  },

  #### ALLOW Habari Vpn into Nip-Proxy VM ###
  "VPN_CIDR_2" = {
    source_cidr      = "10.83.1.10"
    destination_cidr = "100.10.19.90"
  }

}



######### CLUSTER VAR ########
cluster_name           = "afl-demo-cluster"
cce_flavor_id          = "cce.s2.small"
k8_secgroup_name       = "demo-cluster-security-group"
cba_namespace_names    = ["cba", "monitoring"]
noncba_namespace_names = ["noncba", "commandcenter", "monitoring"]



##### IMAGE REPOSITORY SWR ###
swr_organization_name = "afl-controlled"
repository_name       = "afl-controlled-repo"



######## NODEPOOL VAR ############
nodepool_flavor_id = "s6.xlarge.2"
max_node_count     = 10
min_node_count     = 3
node_pool_name     = "controlled-nodepool"     ###nocba-node -pool
node_pool_name_cba = "controlled-nodepool-cba" ### cba-node-pool
key_pair           = "afl-keypair-control"     #### dev-nodepoo-keypair



### VPN-GATEWAY #####
connect_subnet = "10.10.96.0/20" ## public subnet id [0]
# local_subnets = ["10.10.32.0/20", "10.10.0.0/20"]

###### allow ssh access into nip #####
# nip_allowed_ip = [
#   "100.238.79.143"
# ]
# #### allow into bastion access ####
# bastion_allowed_ip = [
#   "10.238.79.143"
# ]
# ##### allow access into demo clusters ####
# k8s_allowed_ip = [
#   "100.10.95.32"
# ]


tags = {
  "env" : "afl-controlled"
}









############  K8S CLUSTER SECURITY-GROUP RULES ################
k8s_sg_rules = {

  rules = [
    {
      direction      = "ingress"
      ethertype      = "IPv4"
      protocol       = "tcp"
      port_range_min = 5443
      port_range_max = 5443
      remote_ip_cidr = "0.0.0.0/0"
    },

    {
      direction      = "ingress"
      ethertype      = "IPv4"
      protocol       = "tcp"
      port_range_min = 443
      port_range_max = 443
      remote_ip_cidr = "0.0.0.0/0"
    },

    {
      direction      = "ingress"
      ethertype      = "IPv4"
      protocol       = "tcp"
      port_range_min = 6443
      port_range_max = 6443
      remote_ip_cidr = "0.0.0.0/0"
    },

  ]


}








############  NIP-VM SECURITY GROUP RULES ################
nip_sg_rules = {
  rules = [
    {
      direction      = "ingress"
      ethertype      = "IPv4"
      protocol       = "tcp"
      port_range_min = 80
      port_range_max = 80
      remote_ip_cidr = "10.154.0.0/20"
      description    = "Allow All Inbound traffic from GCP Environment"
    }
  ]
}


#############  BASTION SECURITY-GROUP  RULES  ############
bastion_sg_rules = {
  rules = [
    {
      direction      = "ingress"
      ethertype      = "IPv4"
      protocol       = "tcp"
      port_range_min = 22
      port_range_max = 22
      remote_ip_cidr = "0.0.0.0/0"
    }

  ]
}




########### GITHUB RUNNER RULES ############
github_runner_rules = {

  rules = [
    #####  ONLY OUINTBOUND TRAFFIC ALLOWED #######
    # {
    #   direction      = "ingress"
    #   ethertype      = "IPv4"
    #   protocol       = "tcp"
    #   port_range_min = 22
    #   port_range_max = 22
    #   remote_ip_cidr = "0.0.0.0/0"
    # },

    #####  ONLY OUTBOUND TRAFFIC ALLOWED #######
    {
      direction      = "egress"
      ethertype      = "IPv4"
      protocol       = "tcp"
      port_range_min = 443
      port_range_max = 443
      remote_ip_cidr = "0.0.0.0/0"
    }

  ]
}






## Node Pool Taints ####
# taints = [
# # {
# # key = null
# # value = null
# # effect = null
# # # },
# # {
# # key = "nodepool"
# # value = "nodepool"
# # effect = "nodepool"
# # },
# # Add more taint groups as needed
# ]
### REDIS VAR ####
# tags = {
# "Env" : "afl-controlled"
# }
