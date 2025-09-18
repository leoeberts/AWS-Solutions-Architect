data "aws_vpc" "study_vpc" {
  id = "vpc-07026206cc7697c1b"
}

data "aws_subnet" "subnet_a" {
  id = "subnet-04c25b7f48e97d567"
}

data "aws_subnet" "subnet_b" {
  id = "subnet-09ae934609adc9a02"
}

data "aws_ami" "latest_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al*-ami-20*-kernel-6*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
