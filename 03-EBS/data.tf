data "aws_vpc" "study_vpc" {
  id = "vpc-07026206cc7697c1b"
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

data "aws_iam_role" "data_lifecycle_full_role" {
  name = "data_lifecycle_full_role"
}
