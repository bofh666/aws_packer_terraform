terraform {
  required_version = "~> 0.12"
}

provider "aws" {
  version = "~> 2.41"
  profile = "default"
  region  = "eu-west-1"
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default_vpc.id}"
}

data "aws_ami" "my_ami" {
  filter {
    name   = "tag:Application"
    values = ["ubuntu_docker_nginx_200"]
  }

  owners      = ["self"]
  most_recent = true
}

resource "aws_security_group" "custom_sg" {
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "custom_sg"
  }
}

resource "aws_launch_configuration" "asg_config" {
  name          = "asg_config"
  image_id      = data.aws_ami.my_ami.id
  instance_type = "t2.micro"
}

resource "aws_elb" "nginx200" {
  name = "nginx200"

  subnets         = data.aws_subnet_ids.all.ids
  security_groups = ["${aws_security_group.custom_sg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "http:80/"
    interval            = 5
  }
}

resource "aws_autoscaling_group" "nginx200_asg" {
  name                 = "nginx200_asg"
  vpc_zone_identifier  = data.aws_subnet_ids.all.ids
  launch_configuration = aws_launch_configuration.asg_config.name
  min_size             = 2
  max_size             = 2
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.nginx200.name]
}

output "nginx_200_dns" {
  value = "${aws_elb.nginx200.dns_name}"
}
