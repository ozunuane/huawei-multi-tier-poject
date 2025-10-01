terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.64.3"
    }
  }
}
# Create Security Group
resource "huaweicloud_networking_secgroup" "this" {
  count                = var.security_group_id == "" ? 1 : 0
  name                 = var.name
  description          = var.description
  delete_default_rules = var.delete_default_rules
}

# Create Security Group Rule
resource "huaweicloud_networking_secgroup_rule" "this" {
  count             = length(var.rules)
  direction         = lookup(var.rules[count.index], "direction")
  ethertype         = lookup(var.rules[count.index], "ethertype")
  protocol          = lookup(var.rules[count.index], "protocol")
  port_range_min    = lookup(var.rules[count.index], "port_range_min")
  port_range_max    = lookup(var.rules[count.index], "port_range_max")
  remote_ip_prefix  = lookup(var.rules[count.index], "remote_ip_cidr")
  security_group_id = var.security_group_id == "" ? huaweicloud_networking_secgroup.this[0].id : var.security_group_id
}


# Create Security Group Rule for allowing communication within the VPC CIDR
resource "huaweicloud_networking_secgroup_rule" "allow_outbound_communication" {
  count             = var.security_group_id == "" ? 1 : 0
  security_group_id = huaweicloud_networking_secgroup.this[0].id
  direction         = "egress"
  ethertype         = "IPv4"
  action            = "allow"
}
