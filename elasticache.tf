resource "aws_elasticache_subnet_group" "terraform_elasticache_subnet_group" {
  provider = aws.main
  name       = local.elasticache_options.elasticache_subnet_group_name
  subnet_ids = [
    aws_subnet.terraform_subnet_public_01.id,
    aws_subnet.terraform_subnet_public_02.id,
    aws_subnet.terraform_subnet_public_03.id,
    aws_subnet.terraform_subnet_private_01.id,
    aws_subnet.terraform_subnet_private_02.id,
    aws_subnet.terraform_subnet_private_03.id
  ]

  tags = {
    Name = local.elasticache_options.elasticache_subnet_group_name
  }
}

resource "aws_elasticache_cluster" "terraform_elasticache" {
  provider = aws.main
  subnet_group_name    = aws_elasticache_subnet_group.terraform_elasticache_subnet_group.name
  cluster_id           = local.elasticache_options.cluster_id
  engine               = local.elasticache_options.engine
  node_type            = local.elasticache_options.node_type
  num_cache_nodes      = local.elasticache_options.num_cache_nodes
  parameter_group_name = local.elasticache_options.parameter_group_name
  engine_version       = local.elasticache_options.engine_version
  port                 = local.elasticache_options.port

  tags = {
    Name = local.elasticache_options.cluster_id
  }

  security_group_ids = [
    aws_security_group.terraform-admin-all-traffic.id,
    aws_vpc.terraform_vpc.default_security_group_id,
    aws_security_group.terraform-elasticache-access.id
  ]
}