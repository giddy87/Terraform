# Internet VPC
resource "aws_vpc" "stn_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "stn_vpc"
  }
}

# Subnets
resource "aws_subnet" "stn_public" {
  vpc_id                  = aws_vpc.stn_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "stn_public"
 }
}


resource "aws_subnet" "stn_private" {
  vpc_id                  = aws_vpc.stn_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "stn_private"
  }
}

# Internet GW
resource "aws_internet_gateway" "stn_igw" {
  vpc_id = aws_vpc.stn_vpc.id

  tags = {
    Name = "stn_igw"
  }
}

# route tables
resource "aws_route_table" "stn_route_public" {
  vpc_id = aws_vpc.stn_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stn_igw.id
  }

  tags = {
    Name = "stn_route_public"
  }
}

# route associations public
resource "aws_route_table_association" "stn_public_assoc" {
  subnet_id      = aws_subnet.stn_public.id
  route_table_id = aws_route_table.stn_route_public.id
}


