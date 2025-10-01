######## VPC VAR #########
cidr                  = "101.10.0.0/16"
vpc_name              = "orionx-dev"
name                  = "orionx"
region                = "af-south-1"
env                   = "dev"
Redis_whitelisted_ips = ["110.0.0/16"]

##### AUTHS #######
terraform_user_id   = "eaexxxxxxxxxxxxx"
terraform_user_name = "terraform"
swr_user_id         = "8aaxxxxxxxxxxxxxxx"
swr_user_name       = "orionxhq"

cloudflare_zone_id = "5a3d2c730592657c38788a16f4ca2b63"
bastion_flavor_id  = "s6.xlarge.2"
##### SUB-DOMAIN$ #######

#### *.test.orionxhq.com ####
cloud_flare_cert_hostnames_prefix = "dev"


##### ALLOW-OUTBOUND TRAFFIC TO EXTERNAL IP'S FROM PRIVATE-NACL ####
vpn_cidr = [
  #### ALLOW ALL ####
  "0.0.0.0/0"
]

# vpc_dissalow = [

#   #### HABARI TEST ENVIRONMENT LOCAL VPN IP
#   "10.10.8.10",

# ]


######## ALLOW-INBOUND TRAFFIC TO VPN TRAFFIC INTO VPC PRIVATE-NACL ########
vpn_inbound_cidr = {
  #### ALLOW ALL into Private VM ###
  "Redis_allow" = {
    source_cidr      = "0.0.0.0"
    destination_cidr = "110.0.0/16"
  }

}




######### CLUSTER VAR ########
cluster_name     = "orionx-dev-cluster1"
cce_flavor_id    = "cce.s2.small"
k8_secgroup_name = "orionx-dev-cluster-security-group"
namespace_names  = ["dev", "monitoring"]


##### IMAGE REPOSITORY SWR ###
swr_organization_name = "orionx-dev"
repository_name       = "orionx-dev-repo"

######## NODEPOOL VARIABLES ############
nodepool_flavor_id = "s6.2xlarge.2"
max_node_count     = 10
min_node_count     = 1
node_pool_name     = "orionx-dev-nodepool-grp"
key_pair           = "orionx-dev-keypair" #### dev-nodepoo-keypair






#### KUBERNETES INGRESS LOAD_BALANCERS #####
# noncba_eip_bandwidth_name_public  = "orionx-dev-nginx-noncba-bd-public-ingress"
# lb_name_public                    = "orionx-dev-ingress-public-noncba"
# noncba_eip_bandwidth_name_private = "orionx-dev-nginx-noncba-bd-private-ingress"
# lb_name_private                   = "orionx-dev-ingress-private-noncba"




tags = {
  "env" : "orionx-dev"
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

    {
      direction      = "ingress"
      ethertype      = "IPv4"
      protocol       = "tcp"
      port_range_min = 5432
      port_range_max = 5432
      remote_ip_cidr = "0.0.0.0/0"
    },

    {
      direction      = "ingress"
      ethertype      = "IPv4"
      protocol       = "tcp"
      port_range_min = 19703
      port_range_max = 19703
      remote_ip_cidr = "0.0.0.0/0"
    },

    {
      direction      = "ingress"
      ethertype      = "IPv4"
      protocol       = "tcp"
      port_range_min = 27017
      port_range_max = 27017
      remote_ip_cidr = "0.0.0.0/0"
    },


    {
      direction      = "ingress"
      ethertype      = "IPv4"
      protocol       = "tcp"
      port_range_min = 6739
      port_range_max = 6739
      remote_ip_cidr = "0.0.0.0/0"
    },


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


#### CLOUDFLARED DNS ###
domain_names = [
  "web-admin",
  "web-admin-dev",
  "emple-general-apigateway-service-dev",
  "emple-general-insurance-service-dev",
  "emple-insurance-customer-mgt-dev",
  "emple-insurance-quotation-eng-service-dev",
  "emple-insurance-underwriting-service-dev"
]





# # Node Pool Taints ####
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
# "Env" : "orionx-dev"
# }






