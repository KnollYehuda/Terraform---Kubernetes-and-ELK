resource "aws_security_group" "terraform-admin-all-traffic" {
  provider = aws.main
  name        = local.security_group_options.admin-all-traffic.name
  description = local.security_group_options.admin-all-traffic.description
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description      = local.security_group_options.admin-all-traffic.owner.description
    from_port        = local.security_group_options.admin-all-traffic.owner.from_port
    to_port          = local.security_group_options.admin-all-traffic.owner.to_port
    protocol         = local.security_group_options.admin-all-traffic.owner.protocol
    cidr_blocks      = local.security_group_options.admin-all-traffic.owner.cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = local.security_group_options.admin-all-traffic.name
  }
}

resource "aws_security_group" "terraform-efs" {
  provider = aws.main
  name        = local.security_group_options.efs_access.name
  description = local.security_group_options.efs_access.description
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description      = local.security_group_options.efs_access.owner.description
    from_port        = local.security_group_options.efs_access.owner.from_port
    to_port          = local.security_group_options.efs_access.owner.to_port
    protocol         = local.security_group_options.efs_access.owner.protocol
    cidr_blocks      = [aws_vpc.terraform_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = local.security_group_options.efs_access.name
  }
}

resource "aws_security_group" "terraform-elasticache-access" {
  provider = aws.main
  name        = local.security_group_options.elasticache_access.name
  description = local.security_group_options.elasticache_access.description
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description      = local.security_group_options.elasticache_access.owner.description
    from_port        = local.security_group_options.elasticache_access.owner.from_port
    to_port          = local.security_group_options.elasticache_access.owner.to_port
    protocol         = local.security_group_options.elasticache_access.owner.protocol
    cidr_blocks      = [aws_vpc.terraform_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = local.security_group_options.elasticache_access.name
  }
}

resource "aws_security_group" "terraform-mysql-access" {
  provider = aws.main
  name        = local.security_group_options.mysql_access.name
  description = local.security_group_options.mysql_access.description
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description      = local.security_group_options.mysql_access.owner.description
    from_port        = local.security_group_options.mysql_access.owner.from_port
    to_port          = local.security_group_options.mysql_access.owner.to_port
    protocol         = local.security_group_options.mysql_access.owner.protocol
    cidr_blocks      = [aws_vpc.terraform_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = local.security_group_options.mysql_access.name
  }
}

resource "aws_security_group" "terraform-elasticsearch-search-and-kibana-access" {
  provider = aws.main
  vpc_id = aws_vpc.terraform_vpc.id
  ingress {
    description = local.security_group_options.elasticsearch_search_access.ssh.description
    from_port   = local.security_group_options.elasticsearch_search_access.ssh.owner.from_port
    to_port     = local.security_group_options.elasticsearch_search_access.ssh.owner.to_port
    protocol    = local.security_group_options.elasticsearch_search_access.ssh.owner.protocol
  }

  ingress {
    description = local.security_group_options.elasticsearch_search_access.search.description
    cidr_blocks = local.security_group_options.elasticsearch_search_access.cidr_global
    from_port   = local.security_group_options.elasticsearch_search_access.search.owner.from_port
    to_port     = local.security_group_options.elasticsearch_search_access.search.owner.to_port
    protocol    = local.security_group_options.elasticsearch_search_access.search.owner.protocol
  }

  ingress {
    description = local.security_group_options.elasticsearch_search_access.kibana.description
    cidr_blocks = local.security_group_options.elasticsearch_search_access.cidr_global
    from_port   = local.security_group_options.elasticsearch_search_access.kibana.owner.from_port
    to_port     = local.security_group_options.elasticsearch_search_access.kibana.owner.to_port
    protocol    = local.security_group_options.elasticsearch_search_access.kibana.owner.protocol
  }

  egress {
    description = "egress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  tags={
    Name=local.security_group_options.elasticsearch_search_access.name
  }
}

resource "aws_security_group" "terraform-elasticsearch-logstash-and-kibana-access" {
  provider = aws.main
  vpc_id = aws_vpc.terraform_vpc.id
  ingress {
    description = local.security_group_options.elasticsearch_search_access.ssh.description
    from_port   = local.security_group_options.elasticsearch_search_access.ssh.owner.from_port
    to_port     = local.security_group_options.elasticsearch_search_access.ssh.owner.to_port
    protocol    = local.security_group_options.elasticsearch_search_access.ssh.owner.protocol
  }

  ingress {
    description = local.security_group_options.elasticsearch_search_access.logstash.description
    cidr_blocks = local.security_group_options.elasticsearch_search_access.cidr_global
    from_port   = local.security_group_options.elasticsearch_search_access.logstash.owner.from_port
    to_port     = local.security_group_options.elasticsearch_search_access.logstash.owner.to_port
    protocol    = local.security_group_options.elasticsearch_search_access.logstash.owner.protocol
  }

  ingress {
    description = local.security_group_options.elasticsearch_search_access.kibana.description
    cidr_blocks = local.security_group_options.elasticsearch_search_access.cidr_global
    from_port   = local.security_group_options.elasticsearch_search_access.kibana.owner.from_port
    to_port     = local.security_group_options.elasticsearch_search_access.kibana.owner.to_port
    protocol    = local.security_group_options.elasticsearch_search_access.kibana.owner.protocol
  }

  egress {
    description = "egress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  tags={
    Name=local.security_group_options.elasticsearch_search_access.name
  }
}
