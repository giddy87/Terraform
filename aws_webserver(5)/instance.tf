resource "aws_instance" "web-instance" {
count = var.instance_count
ami = "ami-0eb89db7593b5d434"
instance_type = "t2.micro"
key_name = aws_key_pair.ec2_key.key_name
user_data = file("install_apache.sh")
vpc_security_group_ids = [aws_security_group.web_server.id]

tags = {
Name = "web-server-${count.index +1}" 
}}
