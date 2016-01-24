resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
}

resource "aws_security_group" "nat" {
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
}


resource "aws_instance" "bastion" {
  ami = "${var.bastion_ami_id}"
  availability_zone = "us-west-1a"
  instance_type = "${var.bastion_instance_type}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.nat.id}", ]
  subnet_id = "${aws_subnet.us-west-1a-public.id}"
  associate_public_ip_address = true
  source_dest_check = false
  tags {
      Name = "auth0-jobtest-bastion-box"
      Environment = "dev"
      Owner = "dominis"
  }
}

resource "aws_nat_gateway" "default" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.us-west-1a-public.id}"
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_eip" "nat" {
  vpc = true
}

# Public subnets
resource "aws_subnet" "us-west-1a-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-1a"
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
}
resource "aws_subnet" "us-west-1c-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1c"
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
}

# Routing table for public subnets
resource "aws_route_table" "us-west-1a-public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
}

resource "aws_route_table_association" "us-west-1a-public" {
  subnet_id = "${aws_subnet.us-west-1a-public.id}"
  route_table_id = "${aws_route_table.us-west-1a-public.id}"
}

resource "aws_route_table" "us-west-1c-public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
}

resource "aws_route_table_association" "us-west-1c-public" {
  subnet_id = "${aws_subnet.us-west-1c-public.id}"
  route_table_id = "${aws_route_table.us-west-1c-public.id}"
}

# Private subsets
resource "aws_subnet" "us-west-1a-private" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-1a"
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
}

resource "aws_subnet" "us-west-1c-private" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "10.0.4.0/24"
  availability_zone = "us-west-1c"
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
}

# Routing table for private subnets
resource "aws_route_table" "us-west-1a-private" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.default.id}"
  }
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
}

resource "aws_route_table_association" "us-west-1a-private" {
  subnet_id = "${aws_subnet.us-west-1a-private.id}"
  route_table_id = "${aws_route_table.us-west-1a-private.id}"
}

resource "aws_route_table" "us-west-1c-private" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.default.id}"
  }
  tags {
      Name = "auth0-jobtest"
      Environment = "dev"
      Owner = "dominis"
  }
}

resource "aws_route_table_association" "us-west-1c-private" {
  subnet_id = "${aws_subnet.us-west-1c-private.id}"
  route_table_id = "${aws_route_table.us-west-1c-private.id}"
}


# DHCP options
resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name = "${var.internalhost}"
  domain_name_servers = ["10.0.0.2"]
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id = "${aws_vpc.default.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}
