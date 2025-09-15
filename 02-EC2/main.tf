resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allows SSH connections and all outbounds"
  vpc_id      = data.aws_vpc.study_vpc.id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv6" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv6         = data.aws_vpc.study_vpc.ipv6_cidr_block
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#### Dynamic IP
resource "aws_instance" "my_instance" {
  ami                    = data.aws_ami.latest_linux.id
  instance_type          = "t2.micro"
  key_name               = data.aws_key_pair.ec2_key.key_name
  subnet_id              = data.aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  iam_instance_profile   = data.aws_iam_instance_profile.ec2_s3_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "My First Instance"
  }
}

# resource "aws_placement_group" "my_cluster_placement_group" {
#   name     = "my_cluster_placement_group"
#   strategy = "cluster"
# }

# resource "aws_instance" "my_cluster_instance" {
#   ami                    = data.aws_ami.latest_linux.id
#   instance_type          = "t3.micro"
#   key_name               = data.aws_key_pair.ec2_key.key_name
#   subnet_id              = data.aws_subnet.public_a.id
#   vpc_security_group_ids = [aws_security_group.allow_ssh.id]
#   iam_instance_profile   = data.aws_iam_instance_profile.ec2_s3_profile.name

#   placement_group = aws_placement_group.my_cluster_placement_group.name

#   tags = {
#     Name = "My First Instance - cluster"
#   }
# }

resource "aws_placement_group" "my_spread_placement_group" {
  name         = "my_spread_placement_group"
  strategy     = "spread"
  spread_level = "rack"
}

resource "aws_instance" "my_spread_instance" {
  ami                    = data.aws_ami.latest_linux.id
  instance_type          = "t3.micro"
  key_name               = data.aws_key_pair.ec2_key.key_name
  subnet_id              = data.aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  iam_instance_profile   = data.aws_iam_instance_profile.ec2_s3_profile.name

  placement_group = aws_placement_group.my_spread_placement_group.name

  tags = {
    Name = "My First Instance - spread"
  }
}

resource "aws_placement_group" "my_partition_placement_group" {
  name            = "my_partition_placement_group"
  strategy        = "partition"
  partition_count = 4
}

resource "aws_instance" "my_partition_instance" {
  ami                    = data.aws_ami.latest_linux.id
  instance_type          = "t3.micro"
  key_name               = data.aws_key_pair.ec2_key.key_name
  subnet_id              = data.aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  iam_instance_profile   = data.aws_iam_instance_profile.ec2_s3_profile.name

  placement_group = aws_placement_group.my_partition_placement_group.name

  tags = {
    Name = "My First Instance - partition"
  }
}

resource "aws_network_interface" "my_eni" {
  subnet_id       = data.aws_subnet.public_a.id
  private_ips     = ["10.2.0.50"]
  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "my_eni - Eth1"
  }
}

resource "aws_network_interface_attachment" "my_eni_attachment" {
  instance_id          = aws_instance.my_partition_instance.id
  network_interface_id = aws_network_interface.my_eni.id
  device_index         = 1
}
