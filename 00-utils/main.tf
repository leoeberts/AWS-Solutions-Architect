resource "aws_key_pair" "my-ec2-key" {
  key_name   = "my-ec2-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCq/ZPuhkxbOvLnK9g71aWvNr+X6+QEa29bLRvhan+o leonardo.eberts@gmail.com"
}

resource "aws_iam_role" "ec2_full_s3_access_role" {
  name        = "s3_full_access_role"
  description = "Give EC2 full access to S3"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_full_access_attach" {
  role       = aws_iam_role.ec2_full_s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_s3_full_access_profile"
  role = aws_iam_role.ec2_full_s3_access_role.name
}

resource "aws_iam_role" "data_lifecycle_full_role" {
  name        = "data_lifecycle_full_role"
  description = "Give full access to control data lifecycle"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

data "aws_iam_policy" "data_lifecycle_policy" {
  name = "AWSDataLifecycleManagerSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.data_lifecycle_full_role.id
  policy_arn = data.aws_iam_policy.data_lifecycle_policy.arn
}

