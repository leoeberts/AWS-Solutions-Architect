resource "aws_security_group" "ec2_sg" {
  name        = "study-ec2-sg"
  description = "Allow traffic from ALB"
  vpc_id      = data.aws_vpc.study_vpc.id

  tags = {
    Name = "study-ec2-sg"
  }
}

resource "aws_security_group_rule" "ec2_ingress_http_from_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ec2_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}


resource "aws_instance" "instance_a" {
  ami                    = data.aws_ami.latest_linux.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from instance_a: $(hostname -f)</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "instance_a"
  }
}

resource "aws_instance" "instance_b" {
  ami                    = data.aws_ami.latest_linux.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.public_b.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from instance_b: $(hostname -f)</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "instance_b"
  }
}
