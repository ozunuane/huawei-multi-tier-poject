variable "security_group_id" {
  description = "The ID of the security group"
  default     = ""
}

variable "security_group_name" {
  description = "The ID of the security group"
  default     = ""
}

variable "name" {

}

variable "description" {
  description = "The description of security group"
  default     = ""
}

variable "delete_default_rules" {
  type        = bool
  description = "Whether or not to delete the default egress security rules"
  default     = true
}


variable "rules" {
  type        = list(map(string))
  description = "List of rules in a security group"
  default = [


  ]
}

variable "vpc_cidr" {

}


  