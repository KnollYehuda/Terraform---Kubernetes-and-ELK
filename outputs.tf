#
# Outputs
#

data "http" "my_ip_v4" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  environment_name = jsondecode(file("./json/env_args.json")).environment_name

  aws_credentials = {
    main_credentials = {
      region = jsondecode(file("./json/env_args.json")).main_region_name
      access_key  = jsondecode(file("./json/env_args.json")).aws_main_access_key
      secret_key  = jsondecode(file("./json/env_args.json")).aws_main_secret_access_key
    }
  }

  google_credentials = {
    project                     = jsondecode(file("./json/env_args.json")).google_project
    region                      = jsondecode(file("./json/env_args.json")).region
    zone                        = jsondecode(file("./json/env_args.json")).zone
    service_account_credentials = file("./json/google_service_account_credentials.json")
  }

  cidr_options = {
    any_v4         = "0.0.0.0/0"
    vpc_cidr       = "172.16.0.0/21"
    subnet_cidr_01 = "172.16.0.0/24"
    subnet_cidr_02 = "172.16.1.0/24"
    subnet_cidr_03 = "172.16.2.0/24"
    subnet_cidr_04 = "172.16.3.0/24"
    subnet_cidr_05 = "172.16.4.0/24"
    subnet_cidr_06 = "172.16.5.0/24"
  }

  vpc_options = {
    name = "${local.environment_name}_vpc"
  }

  subnets_options = {
    name_prefix         = local.environment_name
    public_subnet_01_az = jsondecode(file("./json/env_args.json")).subnet_public_01_availability_zone
    public_subnet_02_az = jsondecode(file("./json/env_args.json")).subnet_public_02_availability_zone
  }

  gateway_options = {
    igw = {
      name = "${local.environment_name}_internet_gateway"
    }

    nat = {
      name = "${local.environment_name}_nat_gateway"
    }
  }

  route_table_options = {
    public = {
      name = "${local.environment_name}_public_route_table"
    }

    private = {
      name = "${local.environment_name}_private_route_table"
    }
  }

  security_group_options = {
    admin-all-traffic = {
      name        = "${local.environment_name}-admin-all-traffic"
      description = "${local.environment_name}-admin-all-traffic"
      owner       = {
        description = "VPC - Owner"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["${chomp(data.http.my_ip_v4.body)}/32"]
      }
    }

    efs_access = {
      name        = "${local.environment_name}-efs-access"
      description = "${local.environment_name}-efs-access"
      owner       = {
        description = "EFS - Access"
        from_port   = 2049
        to_port     = 2049
        protocol    = "tcp"
      }
    }

    elasticache_access = {
      name        = "${local.environment_name}-elasticache-access"
      description = "${local.environment_name}-elasticache-access"
      owner       = {
        description = "ELASTICACHE - Access"
        from_port   = 6379
        to_port     = 6379
        protocol    = "tcp"
      }
    }

    mysql_access = {
      name        = "${local.environment_name}-mysql-access"
      description = "${local.environment_name}-mysql_access-access"
      owner       = {
        description = "MYSQL - Access"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
      }
    }

    elasticsearch_search_access = {
      name          = "${local.environment_name}-elasticsearch-service-access"
      cidr_global   = [ "0.0.0.0/0" ]

      search = {
        name        = "${local.environment_name}-elasticsearch-search-access"
        description = "${local.environment_name}-elasticsearch-search-access"
        owner       = {
          description = "ELASTICSEARCH - SEARCH - Access"
          from_port   = 9200
          to_port     = 9300
          protocol    = "tcp"
        }
      }

      kibana = {
        name        = "${local.environment_name}-elasticsearch-kibana-access"
        description = "${local.environment_name}-elasticsearch-kibana-access"
        owner       = {
          description = "ELASTICSEARCH - KIBANA - Access"
          from_port   = 5601
          to_port     = 5601
          protocol    = "tcp"
        }
      }

      logstash = {
        name        = "${local.environment_name}-elasticsearch-logstash-access"
        description = "${local.environment_name}-elasticsearch-logstash-access"
        owner       = {
          description = "ELASTICSEARCH - LOGSTASH - Access"
          from_port   = 5044
          to_port     = 5044
          protocol    = "tcp"
        }
      }

      ssh = {
        name        = "${local.environment_name}-elasticsearch-ssh-access"
        description = "${local.environment_name}-elasticsearch-ssh-access"
        owner       = {
          description = "ELASTICSEARCH - SSH - Access"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
        }
      }
    }
  }

  elasticache_options = {
    cluster_id                    = local.environment_name
    engine                        = "redis"
    node_type                     = "cache.r6g.xlarge"
    num_cache_nodes               = 1
    parameter_group_name          = "default.redis6.x"
    engine_version                = "6.x"
    port                          = 6379
    elasticache_subnet_group_name = "${local.environment_name}-elasticache-subnet-group"
  }

  rds_options = {
    cluster_identifier      = local.environment_name
    engine                  = "aurora-mysql"
    engine_version          = "5.7.mysql_aurora.2.03.2"
    database_name           = "change_me"
    master_username         = jsondecode(file("./json/env_args.json")).mysql_master_username
    master_password         = jsondecode(file("./json/env_args.json")).mysql_master_password
    backup_retention_period = 5
    preferred_backup_window = "07:00-09:00"
    subnet_group_name       = "${local.environment_name}_subnet_group"
  }

  mq_options = {
    username            = jsondecode(file("./json/env_args.json")).mq_username
    password            = jsondecode(file("./json/env_args.json")).mq_password
    broker_name         = local.environment_name
    engine_type         = "RabbitMQ"
    deployment_mode     = "CLUSTER_MULTI_AZ"
    engine_version      = "3.9.13"
    host_instance_type  = "mq.m5.large"
    publicly_accessible = true
  }

  elasticsearch_options = {
    instance_type               = "c5.xlarge"
    instance_name               = "${local.environment_name}-elasticsearch"
    key_name                    = "${local.environment_name}-key"
    associate_public_ip_address = true
    ami_id                      = jsondecode(file("./json/env_args.json")).elasticsearch_ami

    tags = {
      search-tag-name = "${local.environment_name}-search-and-kibana"
      logs-tag-name   = "${local.environment_name}-logs-and-kibana"
    }
  }

  eks_options = {
    cluster_name    = local.environment_name
    node_group_name = "${local.environment_name}_node_group"

    eks_iam_role = {
      policy = file("./json/eks_iam_role.json")
      name   = "${local.environment_name}_eks_iam_role"
    }

    node_group_iam_role = {
      policy = file("./json/node_group_iam_role.json")
      name   = "${local.environment_name}_node_group_eks_iam_role"
    }

    instance_types = [
      "c5.2xlarge"
    ]

    scaling_config = {
      desired_size = 3
      max_size     = 3
      min_size     = 2
    }

    update_config = {
      max_unavailable = 2
    }
  }

  s3_options = {
    bucket_name     = local.environment_name
    tag_environment = "Prod"
    acl             = "private"
  }

  google_cloud_storage_bucket_options = {
    bucket_name    = local.environment_name
    force_destroy  = true
    storage_class  = "STANDARD"
    access_control = {
      role   = "OWNER"
      entity = jsondecode(file("./json/google_service_account_credentials.json")).client_email
    }
  }

  efs_options = {
    creation_token                  = local.environment_name
    throughput_mode                 = "provisioned"
    provisioned_throughput_in_mibps = 40
  }

  key_pair_options = {
    tls_private_key = {
      algorithm = "RSA"
      rsa_bits  = 4096
    }
    local-exec = {
      interpreter = ["/bin/bash" ,"-c"]
    }
  }

  ami_options = {
      most_recent = true
      filter_name = {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
      }
      filter_virtualization-type = {
        name = "virtualization-type"
        values = ["hvm"]
      }
      owners = ["self"]
    }
}
