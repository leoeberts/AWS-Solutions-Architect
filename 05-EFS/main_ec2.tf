resource "aws_instance" "ec2_a" {
  ami                    = data.aws_ami.latest_linux.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.ssh.id]

  user_data = <<-EOT
              #!/bin/bash
              yum install -y amazon-efs-utils
              mkdir -p /mnt/efs
              echo "${aws_efs_file_system.my_efs.id}:/ /mnt/efs efs defaults,_netdev 0 0" >> /etc/fstab
              mount -a
              EOT

  tags = {
    Name = "ec2-a"
  }
}

resource "aws_instance" "ec2_b" {
  ami                    = data.aws_ami.latest_linux.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.subnet_b.id
  vpc_security_group_ids = [aws_security_group.ssh.id]

  user_data = <<-EOT
              #!/bin/bash
              yum install -y amazon-efs-utils
              mkdir -p /mnt/efs
              echo "${aws_efs_file_system.my_efs.id}:/ /mnt/efs efs defaults,_netdev 0 0" >> /etc/fstab
              mount -a
              EOT

  tags = {
    Name = "ec2-b"
  }
}

resource "aws_security_group" "ssh" {
  name   = "ssh-access"
  vpc_id = data.aws_vpc.study_vpc.id

  tags = {
    Name = "ssh-access"
  }
}

resource "aws_security_group_rule" "allow_ssh_ipv4" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.ssh.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_ssh_ipv6" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.ssh.id
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "allow_all_ipv4" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ssh.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_ipv6" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ssh.id
  ipv6_cidr_blocks  = ["::/0"]
}
