resource "aws_internet_gateway" "terraform_internet_gateway" {
  provider = aws.main
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = local.gateway_options.igw.name
  }
}

resource "aws_nat_gateway" "terraform_nat_gateway" {
  provider = aws.main
  subnet_id     = aws_subnet.terraform_subnet_public_01.id
  connectivity_type = "private"

  tags = {
    Name = local.gateway_options.nat.name
  }

  depends_on = [aws_internet_gateway.terraform_internet_gateway]
}