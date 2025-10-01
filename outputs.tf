output "vpc_id" {
  description = "The VPC ID in UUID format"
  value       = module.vpc.vpc_id
}


output "public_subnets_id" {
  description = "The VPC ID in UUID format"
  value       = module.vpc.public_subnets_ids
}



output "private_subnets_id" {
  description = "The VPC ID in UUID format"
  value       = module.vpc.private_subnets_ids
}



output "availability_zone" {
  value = data.huaweicloud_availability_zones.name
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}


# output "nip_proxy_vm_sg_id" {
#   value = module.nip_proxy_vm_sg
# }

# output "cba_kube_config_raw" {
#   value = module.cba_cluster.kube_config_raw

# }



# output "non_cba_kube_config_raw" {
#   value = module.noncba_cluster.kube_config_raw

# }




# output "origin_certificate_csr_9japay" {
#   value = cloudflare_origin_ca_certificate.cert.csr
# }


# output "root_origin_certificate_csr_9japay" {
#   value = data.cloudflare_origin_ca_root_certificate.cert.cert_pem
# }


# output "certificate_private_key_9japay" {
#   sensitive = true

#   value = tls_cert_request.cert.private_key_pem
# }