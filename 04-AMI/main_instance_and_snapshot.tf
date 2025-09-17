resource "aws_instance" "source_instance" {
  ami           = data.aws_ami.latest_linux.id
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "source_instance"
  }
}

resource "aws_ebs_snapshot" "source_snapshot" {
  volume_id = aws_instance.source_instance.root_block_device.0.volume_id

  tags = {
    Name = "source_snapshot"
  }
}
