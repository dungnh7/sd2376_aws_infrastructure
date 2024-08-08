variable "region" {}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "private_subnet_cidrs" {
  default = ["10.0.0.0/19", "10.0.32.0/19"]
}
variable "public_subnet_cidrs" {
  default = ["10.0.64.0/19", "10.0.96.0/19"]
}
variable "cluster_name" {}