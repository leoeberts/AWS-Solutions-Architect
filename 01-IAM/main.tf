resource "aws_iam_account_password_policy" "password_policy" {
  allow_users_to_change_password = false
  hard_expiry                    = false
  max_password_age               = 1000
  minimum_password_length        = 8
  password_reuse_prevention      = 1
  require_lowercase_characters   = false
  require_numbers                = false
  require_symbols                = false
  require_uppercase_characters   = false
}

resource "aws_iam_user" "user_a" {
  name = "test-user-a"

  tags = {
    Name = "test-user-a"
  }
}

resource "aws_iam_user_policy" "policy_a" {
  name = "test-user-policy-a"
  user = aws_iam_user.user_a.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["ec2:DescribeInstances"]
      Effect   = "Allow"
      Resource = "*"
    }, ]
  })
}

resource "aws_iam_group" "group_a" {
  name = "test-group-a"
}

resource "aws_iam_group_policy" "policy_a" {
  name  = "test-group-policy-a"
  group = aws_iam_group.group_a.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:ListBucket"]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_user_group_membership" "membership_a" {
  user   = aws_iam_user.user_a.name
  groups = [aws_iam_group.group_a.name]
}

resource "aws_iam_user" "user_b" {
  name = "test-user-b"

  tags = {
    Name = "test-user-b"
  }
}

resource "aws_iam_user_policy" "policy_b" {
  name = "test-user-policy-b"
  user = aws_iam_user.user_b.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:ListBucket"]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "IAMReadOnlyAccess_b" {
  user       = aws_iam_user.user_b.name
  policy_arn = data.aws_iam_policy.IAMReadOnlyAccess.arn
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

