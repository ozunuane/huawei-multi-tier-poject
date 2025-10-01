resource "random_string" "key_name" {
  length  = 16
  special = true
  numeric = true
  lower   = true
  upper   = true
}

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}



resource "huaweicloud_kps_keypair" "keypair" {
  name       = "${var.name}-${var.env}-key"
  public_key = tls_private_key.ssh-key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.ssh-key.private_key_pem}' > ${var.name}key.pem
      chmod 400 ${var.name}key.pem
    EOT
  }
}