output "bastion_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "elb_host" {
    value = "http://${aws_elb.jobtest.dns_name}/"
}
