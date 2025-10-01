terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.64.3"
    }
  }
}



data "huaweicloud_images_image" "myimage" {
  name        = "Ubuntu 18.04 server 64bit"
  most_recent = true
}


resource "huaweicloud_compute_instance" "myinstance" {
  name               = "${var.name}-vm-ecs"
  image_id           = data.huaweicloud_images_image.myimage.id
  flavor_id          = var.flavor_id
  key_pair           = var.keypair
  security_group_ids = [var.secgroup_id]
  availability_zone  = var.availability_zone

  network {
    uuid = var.subnet_id
  }

  lifecycle {
    ignore_changes = [name, network, security_group_ids,
    ]
  }
}


resource "huaweicloud_vpc_address_group" "ecs_ip" {
  name = "${var.name}-address"

  addresses = [
    "${huaweicloud_compute_instance.myinstance.access_ip_v4}"
  ]

  # lifecycle {
  #   ignore_changes = [name]
  # }
}

# resource "huaweicloud_vpc_eip" "myeip" {
#   publicip {
#     type = "5_bgp"
#   }
#   bandwidth {
#     name        = "test"
#     size        = 8
#     share_type  = "PER"
#     charge_mode = "traffic"
#   }
# }

# resource "huaweicloud_compute_eip_associate" "associated" {
#   # public_ip   = huaweicloud_vpc_eip.myeip.address
#   instance_id = huaweicloud_compute_instance.myinstance.id
# }