output "elb_host" {
    value = "http://${aws_elb.jobtest.dns_name}/"
}
