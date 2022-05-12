resource "aws_subnet" "terraform_subnet_public_01" {
  provider = aws.main
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = local.cidr_options.subnet_cidr_01
  map_public_ip_on_launch = true
  availability_zone = local.subnets_options.public_subnet_01_az
  tags = {
    Name = "${local.subnets_options.name_prefix}_subnet_public_01"
  }
}

resource "aws_subnet" "terraform_subnet_public_02" {
  provider = aws.main
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = local.cidr_options.subnet_cidr_02
  map_public_ip_on_launch = true
  availability_zone = local.subnets_options.public_subnet_02_az

  tags = {
    Name = "${local.subnets_options.name_prefix}_subnet_public_02"
  }
}

resource "aws_subnet" "terraform_subnet_public_03" {
  provider = aws.main
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = local.cidr_options.subnet_cidr_03
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.subnets_options.name_prefix}_subnet_public_03"
  }
}

resource "aws_subnet" "terraform_subnet_private_01" {
  provider = aws.main
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = local.cidr_options.subnet_cidr_04
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.subnets_options.name_prefix}_subnet_private_01"
  }
}

resource "aws_subnet" "terraform_subnet_private_02" {
  provider = aws.main
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = local.cidr_options.subnet_cidr_05
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.subnets_options.name_prefix}_subnet_private_02"
  }
}

resource "aws_subnet" "terraform_subnet_private_03" {
  provider = aws.main
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = local.cidr_options.subnet_cidr_06
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.subnets_options.name_prefix}_subnet_private_03"
  }
}