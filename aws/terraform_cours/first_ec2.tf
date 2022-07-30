terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.24.0"
    }
  }
}

provider "aws" {
  access_key = ""
  secret_key = ""
  region = "eu-west-3"
}


resource "aws_instance" "web" {
  ami           = "ami-0f5094faf16f004eb"
  instance_type = "t2.micro"
}


resource "aws_eip" "lb" {
	vpc = true
}

resource"aws_eip_association" "eip_asso" {
	instance_id = aws_instance.web.id
	allocation_id = aws_eip.lb.id
}