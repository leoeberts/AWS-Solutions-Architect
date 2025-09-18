resource "aws_efs_file_system" "my_efs" {
  encrypted = true

  #If with wanted a single zone:
  #availability_zone_name = data.aws_subnet.subnet_a.availability_zone

  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }

  tags = {
    Name = "my-efs"
  }
}

resource "aws_security_group" "efs" {
  name   = "my-efs-sg"
  vpc_id = data.aws_vpc.study_vpc.id

  tags = {
    Name = "efs-sg"
  }
}

resource "aws_security_group_rule" "allow_nfs_ipv4" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = aws_security_group.efs.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_egress_ipv4" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.efs.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_efs_mount_target" "mt_a" {
  file_system_id  = aws_efs_file_system.my_efs.id
  subnet_id       = data.aws_subnet.subnet_a.id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "mt_b" {
  file_system_id  = aws_efs_file_system.my_efs.id
  subnet_id       = data.aws_subnet.subnet_b.id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_backup_policy" "backup_policy" {
  file_system_id = aws_efs_file_system.my_efs.id

  backup_policy {
    status = "DISABLED"
  }
}
