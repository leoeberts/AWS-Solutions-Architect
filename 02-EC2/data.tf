data "aws_vpc" "study_vpc" {
  id = "vpc-07026206cc7697c1b"
}

data "aws_subnet" "public_a" {
  id = "subnet-05e4224bbecaac959"
}

data "aws_security_group" "internal_access" {
  id = "sg-0c238bf33f950eba9"
}

data "aws_security_group" "web_access" {
  id = "sg-0d1f26c0f236d0faf"
}

data "aws_key_pair" "ec2_key" {
  key_name = "my-ec2-key"
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

data "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "ec2_s3_full_access_profile"
}
