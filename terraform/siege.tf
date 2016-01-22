resource "aws_instance" "siege" {
  count = 1
  availability_zone = "us-west-1a"
  connection {
    user = "ec2-user"
    key_file = "${var.aws_key_path}"
  }
  instance_type = "${var.proxy_instance_type}"
  ami = "${var.nat_ami_id}"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  subnet_id = "${aws_subnet.us-west-1a-public.id}"
  source_dest_check = false
  associate_public_ip_address = true
  tags {
      Name = "auth0-jobtest-siege"
      Environment = "dev"
      Owner = "dominis"
      Role = "proxy"
  }
}
