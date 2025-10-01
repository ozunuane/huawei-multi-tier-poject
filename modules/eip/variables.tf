variable "name" {
  description = "Specifies the name of the EIP"
  type        = string
  nullable    = false
  default     = "eip"
}

variable "name_postfix" {
  description = "Name Postfix for EIP"
  type        = string

  default = null
}

variable "region" {
  description = "Specifies the region in which to create the resource. If omitted, the provider-level region will be used"
  type        = string
  default     = null
}

variable "eip" {
  description = <<DESCRIPTION
  EIP configuration
  Possible values for type are '5_bgp' (dynamic BGP) and '5_sbgp' (static BGP)
  DESCRIPTION
  type = object({
    type       = optional(string, "5_bgp")
    ip_address = optional(string, null)
    ip_version = optional(number, 4)
    bandwidth = object({
      size        = optional(number, 5)
      share_type  = optional(string, "PER")
      charge_mode = optional(string, "traffic")
    })
  })
  default = {
    bandwidth = {}
  }
}

variable "auto_renew" {
  description = "Specifies whether auto renew is enabled"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Specifies the key/value pairs to associate with the VPC"
  type        = map(string)
  default     = {}
}

variable "env" {

}