#### STAGING CLOUDFLARE RECORDS ####
module "records_A" {
  count              = terraform.workspace == "dev" ? 1 : 0
  source             = "./modules/cloudflare/records"
  domains            = var.domain_names
  cloudflare_zone_id = var.cloudflare_zone_id
  type               = "A"
  ### ELB IP ADDRESS ##
  ip_address = "203.123.80.236"
}



