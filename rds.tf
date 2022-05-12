resource "aws_db_subnet_group" "terraform_db_subnet_group" {
  provider = aws.main
  name = local.rds_options.subnet_group_name
  subnet_ids = [
    aws_subnet.terraform_subnet_public_01.id,
    aws_subnet.terraform_subnet_public_02.id,
  ]

  tags = {
    Name = local.rds_options.subnet_group_name
  }
}

resource "aws_rds_cluster" "terraform_rds_cluster" {
  provider = aws.main
  cluster_identifier      = local.rds_options.cluster_identifier
  engine                  = local.rds_options.engine
  engine_version          = local.rds_options.engine_version
  availability_zones      = [
    aws_subnet.terraform_subnet_public_01.availability_zone,
    aws_subnet.terraform_subnet_public_02.availability_zone,
  ]
  database_name           = local.rds_options.database_name
  master_username         = local.rds_options.master_username
  master_password         = local.rds_options.master_password
  backup_retention_period = local.rds_options.backup_retention_period
  preferred_backup_window = local.rds_options.preferred_backup_window
  source_region           = local.aws_credentials.main_credentials.region
  db_subnet_group_name    = aws_db_subnet_group.terraform_db_subnet_group.name
  skip_final_snapshot     = true

  vpc_security_group_ids = [
    aws_security_group.terraform-admin-all-traffic.id,
    aws_vpc.terraform_vpc.default_security_group_id,
    aws_security_group.terraform-mysql-access.id
  ]

  lifecycle {
    ignore_changes        = [
      engine_version,
      cluster_identifier,
      availability_zones
    ]
  }
}

resource "aws_rds_cluster_instance" "terraform_cluster_instances" {
  provider = aws.main
  count              = 2
  identifier         = "${local.rds_options.cluster_identifier}-cluster-instances-${count.index}"
  cluster_identifier = aws_rds_cluster.terraform_rds_cluster.id
  instance_class     = "db.r5.xlarge"
  engine             = aws_rds_cluster.terraform_rds_cluster.engine
  engine_version     = aws_rds_cluster.terraform_rds_cluster.engine_version
  publicly_accessible = true

  lifecycle {
    ignore_changes        = [
      engine_version,
      cluster_identifier
    ]
  }
}
