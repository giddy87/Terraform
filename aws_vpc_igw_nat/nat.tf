# Elastic ip
resource "aws_eip" "nat_eip" {
  vpc = true
}

# Nat GW
resource "aws_nat_gateway" "stn_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.stn_private.id
  depends_on    = [aws_internet_gateway.stn_igw]
tags = {
Name = "stn_nat"
}
}

# NAT route table
resource "aws_route_table" "stn_private_route" {
  vpc_id = aws_vpc.stn_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.stn_nat.id
  }

  tags = {
    Name = "stn_private_route"
  }
}

# route associations private
resource "aws_route_table_association" "stn_private_assoc" {
  subnet_id      = aws_subnet.stn_private.id
  route_table_id = aws_route_table.stn_private_route.id
}

