resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "var.name-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_ap_south_1a.id

  tags = {
    Name = "var.name-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}
