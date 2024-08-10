variable "ami_id" {
  default = "ami-059b4390a17fbed33"
}
variable "instance_type" {
  default = "t3.small"
}
variable "subnet_id" {}
variable "security_group_id" {}
variable "key_name" {
  default = "sd2376-key-name-ec2"
}