
# variable "name" {}
# variable "vpc_id" {}
# variable "subnet_id" {}
# variable "bandwidth_name1" {}

# data "huaweicloud_vpn_gateway_availability_zones" "test" {
#   flavor          = "professional1"
#   attachment_type = "vpc"
# }

# resource "huaweicloud_vpn_gateway" "test" {
#   name               = var.name
#   vpc_id             = var.vpc_id
#   local_subnets      = ["192.168.0.0/24", "192.168.1.0/24"]
#   connect_subnet     = var.subnet_id
#   availability_zones = [
#     data.huaweicloud_vpn_gateway_availability_zones.test.names[0],
#     data.huaweicloud_vpn_gateway_availability_zones.test.names[1]
#   ]

#   eip1 {
#     bandwidth_name = var.bandwidth_name1
#     type           = "5_bgp"
#     bandwidth_size = 5
#     charge_mode    = "traffic"
#   }
# }