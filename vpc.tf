resource "aws_vpc" "terraform_vpc" {
  provider = aws.main
  cidr_block = local.cidr_options.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = local.vpc_options.name
  }
}