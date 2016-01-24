variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "node_ami_id" {}
variable "proxy_ami_id" {}

variable "aws_key_path" {
  default = "~/.ssh/jobtest-auth0"
}
variable "aws_key_name" {
  default = "auth0-jobtest"
}
variable "aws_region" {
  default = "us-west-1"
}
variable "aws_availability_zones" {
  default = "us-west-1a,us-west-1c"
}
variable "internalhost" {
  default = "jobtest.aws"
}
variable "bastion_ami_id" {
  default = "ami-d5ea86b5"
}
variable "bastion_instance_type" {
  default = "t2.nano"
}
variable "node_instance_type" {
  default = "t2.medium"
}
variable "proxy_instance_type" {
  default = "m4.large"
}

variable "asg_number_of_instances" {
  default = 2
}
variable "asg_maximum_number_of_instances" {
  default = 10
}
variable "asg_minimum_number_of_instances" {
  default = 2
}
