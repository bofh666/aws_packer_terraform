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

resource "aws_instance" "ubuntu_docker_nginx_200" {

  count = 1

  instance_type          = "t2.micro"
  ami                    = data.aws_ami.my_ami.id
  vpc_security_group_ids = ["${aws_security_group.custom_sg.id}"]

  tags = {
    Name = "ubuntu_docker_nginx_200"
  }

  lifecycle {
    ignore_changes = [private_ip, root_block_device, ebs_block_device]
  }
}

output "instances_dns" {
  value = "${aws_instance.ubuntu_docker_nginx_200.*.public_dns}"
}
