resource "aws_mq_broker" "terraform_mq_broker" {
  provider = aws.main
  broker_name        = local.mq_options.broker_name
  engine_type        = local.mq_options.engine_type
  deployment_mode    = local.mq_options.deployment_mode
  engine_version     = local.mq_options.engine_version
  host_instance_type = local.mq_options.host_instance_type
  publicly_accessible = local.mq_options.publicly_accessible


  user {
    username = local.mq_options.username
    password = local.mq_options.password
  }
}