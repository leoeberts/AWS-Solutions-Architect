data "aws_vpc" "study_vpc" {
  id = "vpc-07026206cc7697c1b"
}

data "aws_subnet" "public_a" {
  id = "subnet-05e4224bbecaac959"
}

data "aws_subnet" "public_b" {
  id = "subnet-09ae934609adc9a02"
}

data "aws_subnet" "public_c" {
  id = "subnet-07407cc7609690225"
}

data "aws_subnet" "private_a" {
  id = "subnet-04c25b7f48e97d567"
}

data "aws_subnet" "private_b" {
  id = "subnet-0e32c427fbfaed4bb"
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
