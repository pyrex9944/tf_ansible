terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                  = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "alice" {
  key_name      = aws_key_pair.alice.key_name
  
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"

  vpc_security_group_ids = [ aws_security_group.allow_ingress.id, aws_security_group.allow_egress.id ]
  tags = {
    Name = "Terraform test EC2"
  }
}

resource "aws_security_group" "allow_ingress" {
  vpc_id      = data.aws_vpc.default.id
  
  name        = "allow_ingress"
  description = "Allow ingress"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_egress" {
  vpc_id      = data.aws_vpc.default.id

  name        = "allow_egress"
  description = "Allow egress"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
