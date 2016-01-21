resource "aws_elb" "jobtest" {
  name = "jobtest-elb"

  security_groups = ["${aws_security_group.nat.id}"]
  subnets = ["${aws_subnet.us-west-1a-public.id}", "${aws_subnet.us-west-1c-public.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 5
  }

  instances = ["${aws_instance.proxy-1a.id}", "${aws_instance.proxy-1c.*.id}"]

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
      Role = "proxy"
  }
}

resource "aws_instance" "proxy-1a" {
  count = 1
  connection {
    user = "ec2-user"
    key_file = "${var.key_path}"
  }
  instance_type = "${var.proxy_instance_type}"
  ami = "${var.proxy_ami_id}"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  subnet_id = "${aws_subnet.us-west-1a-public.id}"
  tags {
      Name = "auth0-jobtest-proxy-1a"
      Environment = "dev"
      Owner = "dominis"
      Role = "proxy"
  }
}

resource "aws_instance" "proxy-1c" {
  depends_on = ["aws_instance.proxy-1a"]
  count = 2
  connection {
    user = "ec2-user"
    key_file = "${var.key_path}"
  }
  instance_type = "${var.proxy_instance_type}"
  ami = "${var.proxy_ami_id}"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  subnet_id = "${aws_subnet.us-west-1c-public.id}"
  tags {
      Name = "${format("auth0-jobtest-proxy-1c-%03d", count.index + 1)}"
      Environment = "dev"
      Owner = "dominis"
      Role = "proxy"
  }
  user_data = "#!/bin/bash\nsed -i 's/127.0.0.1/${aws_instance.proxy-1a.private_ip}/g' /etc/consul/config.json"
}
