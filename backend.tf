
# terraform {
#   backend "gcs" {

#     bucket = ""
#   }
# }



# terraform {
#   backend "local" {
#     path = "default.state" # Path to your local state file
#   }
# }

terraform {
  backend "s3" {
    region                      = "af-south-1"
    endpoint                    = "https://obs.af-south-1.myhuaweicloud.com"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}





