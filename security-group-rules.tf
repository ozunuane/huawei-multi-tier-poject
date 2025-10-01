# ############  K8S CLUSTER SECURITY-GROUP RULES ################
variable "k8s_sg_rules" {
  type = map(any)

}

# ########### GITHUB RUNNER RULES ############
# variable "github_runner_rules" {

#   type = map(any)

# }

#############  BASTION SECURITY-GROUP  RULES  ############
variable "bastion_sg_rules" {
  type = map(any)

}

# ######### NIP SECURITY GROUP RULES ########
# variable "nip_sg_rules" {
#   type = map(any)
# }


# variable "dev_sg_rules" {

#   type = map(any)
#   default = {
#     rules = [
#       {
#         direction      = "ingress"
#         ethertype      = "IPv4"
#         protocol       = "tcp"
#         port_range_min = 22
#         port_range_max = 22
#         remote_ip_cidr = "0.0.0.0/0"
#       },
#       {
#         direction      = "ingress"
#         ethertype      = "IPv4"
#         protocol       = "tcp"
#         port_range_min = 443
#         port_range_max = 443
#         remote_ip_cidr = "0.0.0.0/0"
#       }


#     ]
#   }
# }



