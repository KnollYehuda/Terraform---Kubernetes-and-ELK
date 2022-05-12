resource "aws_route_table" "terraform_public_route_table" {
  provider = aws.main
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = local.cidr_options.any_v4
    gateway_id = aws_internet_gateway.terraform_internet_gateway.id
  }

  tags = {
    Name = local.route_table_options.public.name
  }

  lifecycle {
    ignore_changes        = [route]
  }
}

resource "aws_route_table_association" "terraform_public_route_table_association_subnet_01" {
  provider = aws.main
  subnet_id      = aws_subnet.terraform_subnet_public_01.id
  route_table_id = aws_route_table.terraform_public_route_table.id
}

resource "aws_route_table_association" "terraform_public_route_table_association_subnet_02" {
  provider = aws.main
  subnet_id      = aws_subnet.terraform_subnet_public_02.id
  route_table_id = aws_route_table.terraform_public_route_table.id
}

resource "aws_route_table_association" "terraform_public_route_table_association_subnet_03" {
  provider = aws.main
  subnet_id      = aws_subnet.terraform_subnet_public_03.id
  route_table_id = aws_route_table.terraform_public_route_table.id
}

resource "aws_route_table" "terraform_private_route_table" {
  provider = aws.main
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = local.cidr_options.any_v4
    gateway_id = aws_nat_gateway.terraform_nat_gateway.id
  }

  tags = {
    Name = local.route_table_options.private.name
  }

  lifecycle {
    ignore_changes        = [route]
  }
}

resource "aws_route_table_association" "terraform_private_route_table_association_subnet_04" {
  provider = aws.main
  subnet_id      = aws_subnet.terraform_subnet_private_01.id
  route_table_id = aws_route_table.terraform_private_route_table.id
}

resource "aws_route_table_association" "terraform_private_route_table_association_subnet_05" {
  provider = aws.main
  subnet_id      = aws_subnet.terraform_subnet_private_02.id
  route_table_id = aws_route_table.terraform_private_route_table.id
}

resource "aws_route_table_association" "terraform_private_route_table_association_subnet_06" {
  provider = aws.main
  subnet_id      = aws_subnet.terraform_subnet_private_03.id
  route_table_id = aws_route_table.terraform_private_route_table.id
}
