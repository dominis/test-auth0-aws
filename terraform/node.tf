resource "aws_launch_configuration" "launch_config" {
  name = "jobtest-lc"
  image_id = "${var.node_ami_id}"
  instance_type = "${var.node_instance_type}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.nat.id}"]
  key_name = "${var.aws_key_name}"
  #user_data = "${file(var.user_data)}"

}

resource "aws_autoscaling_group" "main_asg" {
  depends_on = ["aws_launch_configuration.launch_config"]

  name = "jobtest-asg"

  availability_zones = ["${split(",", var.aws_availability_zones)}"]
  vpc_zone_identifier = ["${aws_subnet.us-west-1a-public.id}", "${aws_subnet.us-west-1c-public.id}"]

  launch_configuration = "${aws_launch_configuration.launch_config.id}"

  max_size = "${var.asg_maximum_number_of_instances}"
  min_size = "${var.asg_minimum_number_of_instances}"
  desired_capacity = "${var.asg_number_of_instances}"

  health_check_grace_period = "10"
  health_check_type = "EC2"

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

resource "aws_autoscaling_policy" "node" {
    name = "jobtest-asg-policy"
    scaling_adjustment = 2
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = "${aws_autoscaling_group.main_asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "node" {
    alarm_name = "jobtest-watch"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "60"
    statistic = "Average"
    threshold = "70"
    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.main_asg.name}"
    }
    alarm_description = "app node ec2 cpu utilization"
    alarm_actions = ["${aws_autoscaling_policy.node.arn}"]
}
