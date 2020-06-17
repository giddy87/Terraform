resource "aws_key_pair" "ec2_key" {
key_name = "mykey"
public_key = file(var.PATH_TO_PUBLIC_KEY)
}
