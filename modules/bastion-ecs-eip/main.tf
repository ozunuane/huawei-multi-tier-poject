terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.64.3"
    }
  }
}

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
  name       = "${var.name}-${var.env}-bastion-key"
  public_key = tls_private_key.ssh-key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.ssh-key.private_key_pem}' > ${var.name}key.pem
      chmod 400 ${var.name}key.pem
    EOT
  }
}


data "huaweicloud_images_image" "myimage" {
  name        = "Ubuntu 22.04 server 64bit"
  most_recent = false
}



######### create bastion instance
resource "huaweicloud_compute_instance" "myinstance" {
  name               = "${var.name}-${var.env}-bastion"
  image_id           = data.huaweicloud_images_image.myimage.id
  flavor_id          = var.flavor_id
  key_pair           = huaweicloud_kps_keypair.keypair.name
  security_group_ids = [var.secgroup_id]
  availability_zone  = var.availability_zone
  admin_pass         = random_string.key_name.result
  user_id            = var.user_id ##tf user id##


  network {
    uuid = var.subnet_id[0]
  }

  lifecycle {
    ignore_changes = [
      user_id, security_group_ids, availability_zone
    ]
  }
  depends_on = [huaweicloud_kps_keypair.keypair, tls_private_key.ssh-key]

}


#### elastic ip ####
resource "huaweicloud_vpc_eip" "myeip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "${var.name}-${var.env}bastion-eip"
    size        = 8
    share_type  = "PER"
    charge_mode = "traffic"
  }
  lifecycle {
    ignore_changes = []
  }

}


#### associate ip with instancce #####
resource "huaweicloud_compute_eip_associate" "associated" {
  public_ip   = huaweicloud_vpc_eip.myeip.address
  instance_id = huaweicloud_compute_instance.myinstance.id

}




resource "null_resource" "install" {
  triggers = {
    on_creation = huaweicloud_compute_instance.myinstance.id
    # instance_attr_changes = huaweicloud_compute_instance.myinstance.id
    # always_run = timestamp() # Current timestamp ensures it always runs

  }
}




resource "null_resource" "update" {
  triggers = {
    server = huaweicloud_compute_instance.myinstance.id
    # install = null_resource.install.id
    # always_run = timestamp() # Current timestamp ensures it always runs

    # config_hash             = var.config_hash
    # deployment_cache_buster = var.deployment_cache_buster
    # service_account         = base64decode(google_service_account_key.bastion.private_key)
  }



  connection {
    type = "ssh"
    host = huaweicloud_vpc_eip.myeip.address
    # host_key = tls_private_key.ssh-key.public_key_openssh
    # host = huaweicloud_compute_instance.myinstance.access_ip_v4
    private_key = tls_private_key.ssh-key.private_key_pem
    password    = random_string.key_name.result
  }

  provisioner "remote-exec" {
    inline = [
      "directory=.kube",
      "config_file=\"$directory/config.yml\"",
      "if [ -d \"$directory\" ]; then",
      "  echo \"Directory '$directory' already exists.\"",
      "  sudo rm -rf \"$directory\"",
      "  echo \"Directory '$directory' and its contents deleted successfully.\"",
      "fi",
      "sudo mkdir -p \"$directory\"",
      "echo \"Directory '$directory' created successfully.\"",
      "sudo touch \"$config_file\"",
      "echo \"File '$config_file' created successfully.\""
    ]
  }





  # update service account credential file
  provisioner "file" {
    content     = var.kube_config_raw
    destination = "/root/.kube/config.yml"

  }



  provisioner "remote-exec" {
    inline = [
      "echo '⌛️ Updating kubectl config...'",

      # Update dependencies
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list",

      # Install kubectl for x86_64
      "curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl",
      "curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256",
      "echo \"$(cat kubectl.sha256)  kubectl\" | sha256sum --check",
      "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl",

      #Install Kustomize
      "curl -sfLo kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v3.1.0/kustomize_3.1.0_linux_amd64",
      "chmod u+x ./kustomize",

      # Configure kubectl contexts
      "alias kubectl='kubectl --kubeconfig /root/.kube/config.yml'",
      "kubectl config use-context internal --namespace=dev  ",
      "kubectl cluster-info",


      "echo '✅ Updated kubectl config.'",
    ]
  }






  depends_on = [huaweicloud_compute_instance.myinstance, null_resource.install, huaweicloud_compute_eip_associate.associated]

}

