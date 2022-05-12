resource "aws_efs_file_system" "terraform_efs" {
  provider = aws.main
  creation_token = local.efs_options.creation_token
  throughput_mode = local.efs_options.throughput_mode
  provisioned_throughput_in_mibps = local.efs_options.provisioned_throughput_in_mibps

  tags = {
    Name = local.eks_options.cluster_name
  }
}

resource "aws_efs_mount_target" "terraform_efs_mt_public_01" {
  provider = aws.main
  file_system_id = aws_efs_file_system.terraform_efs.id
  subnet_id      = aws_subnet.terraform_subnet_public_01.id
  security_groups = [
    aws_vpc.terraform_vpc.default_security_group_id,
    aws_security_group.terraform-efs.id
  ]
}

resource "aws_efs_mount_target" "terraform_efs_mt_public_02" {
  provider = aws.main
  file_system_id = aws_efs_file_system.terraform_efs.id
  subnet_id      = aws_subnet.terraform_subnet_public_02.id
  security_groups = [
    aws_vpc.terraform_vpc.default_security_group_id,
    aws_security_group.terraform-efs.id
  ]
}
