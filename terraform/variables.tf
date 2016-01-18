variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {
  default = "~/.ssh/jobtest-auth0"
}
variable "aws_key_name" {
  default = "auth0-jobtest"
}
variable "aws_region" {
  default = "us-west-1"
}
variable "nat_ami_id" {
  default = "ami-d5ea86b5"
}
variable "nat_instance_type" {
  default = "t2.nano"
}
