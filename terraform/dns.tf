resource "aws_route53_zone" "jobtest" {
  name = "${var.internalhost}"
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
}
