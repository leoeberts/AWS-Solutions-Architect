# #### Elastic IP
# resource "aws_eip" "my_eip" {}

# # using aws_eip_association so the EIP lifecycle is separate from the instance.
# #  meaning it will not destroy and re-create eip when attach it to something else
# resource "aws_eip_association" "eapi_ec2_assoc" {
#   instance_id   = aws_instance.my_instance_eip.id
#   allocation_id = aws_eip.my_eip.id
# }
# resource "aws_instance" "my_instance_eip" {
#   ami                    = data.aws_ami.latest_linux.id
#   instance_type          = "t2.micro"
#   key_name               = data.aws_key_pair.ec2_key.key_name
#   subnet_id              = data.aws_subnet.public_a.id
#   vpc_security_group_ids = [aws_security_group.allow_ssh.id]
#   iam_instance_profile   = data.aws_iam_instance_profile.ec2_s3_profile.name

#   # not needed, but prevents an ephemeral dynamic public IP at launch
#   associate_public_ip_address = false

#   user_data = <<-EOF
#               #!/bin/bash
#               yum update -y
#               yum install -y httpd
#               systemctl start httpd
#               systemctl enable httpd
#               echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
#               EOF

#   tags = {
#     Name = "My First EIP Instance"
#   }
# }
# 
# output "ec2_eip" {
#   value = aws_instance.my_instance_eip.public_ip
# }
# 
# output "eip" {
#   value = aws_eip.my_eip.public_ip
# }
# output "ec2_dynamic_ip" {
#   value = aws_instance.my_instance.public_ip
# }
