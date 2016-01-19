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

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
      Role = "node"
  }
}


resource "aws_launch_configuration" "launch_config" {
  name = "jobtest-lc"
  image_id = "${var.node_ami_id}"
  instance_type = "${var.node_instance_type}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.nat.id}"]
  #user_data = "${file(var.user_data)}"

}

resource "aws_autoscaling_group" "main_asg" {
  depends_on = ["aws_launch_configuration.launch_config"]

  name = "jobtest-asg"

  availability_zones = ["${split(",", var.aws_availability_zones)}"]
  vpc_zone_identifier = ["${aws_subnet.us-west-1a-public.id}", "${aws_subnet.us-west-1c-public.id}"]

  launch_configuration = "${aws_launch_configuration.launch_config.id}"

  max_size = "${var.asg_number_of_instances}"
  min_size = "${var.asg_minimum_number_of_instances}"
  desired_capacity = "${var.asg_number_of_instances}"

  health_check_grace_period = "10"
  health_check_type = "ELB"

  load_balancers = ["${aws_elb.jobtest.name}"]
  tag {
    key = "Name"
    value = "auth0-jobtest-node-ASG"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "dev"
    propagate_at_launch = true
  }
  tag {
    key = "Owner"
    value = "dominis"
    propagate_at_launch = true
  }
  tag {
    key = "Role"
    value = "node"
    propagate_at_launch = true
  }
}


