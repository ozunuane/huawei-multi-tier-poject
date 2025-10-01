variable "ip_address" {
  type = string
}


variable "cloudflare_zone_id" {

}

variable "domains" {
  type = list(string)
}

variable "type" {
  default = "A"
}