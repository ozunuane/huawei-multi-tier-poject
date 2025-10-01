variable "vpc_id" {}
variable "subnet_id" {}
variable "secgroup_id" {}
variable "availability_zone" {}
variable "name" {}
variable "env" {}
variable "db_zize" {
  default = 100
}
variable "flavor" {
  default = "rds.pg.n1.large.2"
}