variable "ami_id" {
  default = "ami-0b13630a979679b27"
}
variable "instance_type" {
  default = "t3a.micro"
}
variable "subnet_id" {}
variable "security_group_id" {}
variable "key_name" {
  default = "sd2376-key_name-ec2"
}