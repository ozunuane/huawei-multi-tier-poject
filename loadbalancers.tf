# #### NONCBA PUBLIC INGRESS LB #####
# resource "huaweicloud_vpc_eip" "ingress_public_eip" {
#   bandwidth {
#     charge_mode = "traffic"
#     name        = var.noncba_eip_bandwidth_name_public
#     share_type  = "PER"
#     size        = 300
#   }
#   publicip {
#     type = "5_bgp"
#   }
# }


# resource "huaweicloud_elb_loadbalancer" "ingress_public" {
#   autoscaling_enabled = true
#   availability_zone = [
#     "af-south-1a",
#     "af-south-1b",
#   ]
#   backend_subnets = [
#     "${module.vpc.public_subnets_ids[0]}",
#   ]
#   enterprise_project_id = "0"
#   ipv4_eip_id           = huaweicloud_vpc_eip.ingress_public_eip.id
#   #   ipv4_address          = "100.10.12.2"
#   # ipv4_subnet_id = "f1072a1c-ee0e-495d-ac51-7af0c8aa430e"
#   name   = var.lb_name_public
#   region = var.region
#   vpc_id = module.vpc.vpc_id
# }


# ####### NONCBA PRIVATE INGRESS LB #########
# # resource "huaweicloud_vpc_eip" "ingress_private_eip" {
# #   bandwidth {
# #     charge_mode = "traffic"
# #     name        = var.noncba_eip_bandwidth_name_private
# #     share_type  = "PER"
# #     size        = 300
# #   }
# #   publicip {
# #     type = "5_bgp"
# #   }
# # }

# # resource "huaweicloud_elb_loadbalancer" "ingress_private" {
# #   autoscaling_enabled = true
# #   availability_zone = [
# #     "af-south-1a",
# #     "af-south-1b",
# #   ]
# #   backend_subnets = [
# #     "${module.vpc.private_subnets_ids[0]}",
# #   ]
# #   enterprise_project_id = "0"
# #   #   ipv4_eip_id           = huaweicloud_vpc_eip.ingress_private_eip.id
# #   name = var.lb_name_private
# #   #   ipv4_subnet_id = module.vpc.private_subnets_ids[0]
# #   ipv4_subnet_id = "f1072a1c-ee0e-495d-ac51-7af0c8aa430e"

# #   #   ipv4_address = "100.10.11.2"
# #   region = var.region
# #   vpc_id = module.vpc.vpc_id
# # }

