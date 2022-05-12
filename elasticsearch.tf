resource "aws_instance" "terraform-elasticsearch-search-and-kibana" {
  provider               = aws.main
  ami                    = local.elasticsearch_options.ami_id
  instance_type          = local.elasticsearch_options.instance_type
  subnet_id              = aws_subnet.terraform_subnet_public_01.id
  vpc_security_group_ids = [
    aws_security_group.terraform-admin-all-traffic.id,
    aws_vpc.terraform_vpc.default_security_group_id,
    aws_security_group.terraform-elasticsearch-search-and-kibana-access.id
  ]
  key_name                    = aws_key_pair.terraform-elasticsearch-key-pair.key_name
  associate_public_ip_address = local.elasticsearch_options.associate_public_ip_address

  tags = {
    Name = local.elasticsearch_options.tags.search-tag-name
  }
}

resource "aws_instance" "terraform-elasticsearch-logstash-and-kibana" {
  provider               = aws.main
  ami                    = local.elasticsearch_options.ami_id
  instance_type          = local.elasticsearch_options.instance_type
  subnet_id              = aws_subnet.terraform_subnet_public_01.id
  vpc_security_group_ids = [
    aws_security_group.terraform-admin-all-traffic.id,
    aws_vpc.terraform_vpc.default_security_group_id,
    aws_security_group.terraform-elasticsearch-logstash-and-kibana-access.id
  ]
  key_name                    = aws_key_pair.terraform-elasticsearch-key-pair.key_name
  associate_public_ip_address = local.elasticsearch_options.associate_public_ip_address

  tags = {
    Name = local.elasticsearch_options.tags.logs-tag-name
  }
}
