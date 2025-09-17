resource "aws_ami" "from_snapshot" {
  name                = "from_snapshot"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = aws_ebs_snapshot.source_snapshot.id
  }
}

resource "aws_instance" "from_snapshot_ami" {
  ami           = aws_ami.from_snapshot.id
  instance_type = "t2.micro"

  tags = {
    Name = "from_snapshot_ami"
  }
}

resource "aws_ami_from_instance" "from_instance" {
  name               = "from_instance"
  source_instance_id = aws_instance.source_instance.id
}

resource "aws_instance" "from_instance_ami" {
  ami           = aws_ami_from_instance.from_instance.id
  instance_type = "t2.micro"

  tags = {
    Name = "from_instance_ami"
  }
}
