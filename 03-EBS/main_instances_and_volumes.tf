resource "aws_ebs_volume" "dettached_volume" {
  availability_zone = aws_instance.instance_a.availability_zone
  type              = "gp2"
  size              = 1

  tags = {
    Name = "dettached_volume"
  }
}

########## Single EBS
resource "aws_instance" "instance_a" {
  ami           = data.aws_ami.latest_linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "instance_a"
  }
}

resource "aws_ebs_volume" "attached_volume_a" {
  availability_zone = aws_instance.instance_a.availability_zone
  type              = "gp2"
  size              = 1

  tags = {
    Name = "attached_volume_a"
  }
}

resource "aws_volume_attachment" "ebs_a_att" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.attached_volume_a.id
  instance_id = aws_instance.instance_a.id
}

########## Multi EBS
resource "aws_instance" "instance_b" {
  ami           = data.aws_ami.latest_linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "instance_a"
  }
}

resource "aws_ebs_volume" "attached_volume_b1" {
  availability_zone = aws_instance.instance_b.availability_zone
  type              = "gp2"
  size              = 1

  tags = {
    Name = "attached_volume_b1"
  }
}

resource "aws_volume_attachment" "ebs_b1_att" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.attached_volume_b1.id
  instance_id = aws_instance.instance_b.id
}

resource "aws_ebs_volume" "attached_volume_b2" {
  availability_zone = aws_instance.instance_b.availability_zone
  type              = "gp2"
  size              = 1

  tags = {
    Name = "attached_volume_b2"
  }
}

resource "aws_volume_attachment" "ebs_b2_att" {
  device_name = "/dev/sde"
  volume_id   = aws_ebs_volume.attached_volume_b2.id
  instance_id = aws_instance.instance_b.id
}
