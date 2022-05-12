resource "aws_eks_cluster" "terraform_eks_cluster" {
  provider = aws.main
  name     = local.eks_options.cluster_name
  role_arn = aws_iam_role.terraform_eks_iam_role.arn
  version = 1.22
  vpc_config {
    subnet_ids = [
      aws_subnet.terraform_subnet_public_01.id,
      aws_subnet.terraform_subnet_public_02.id,
      aws_subnet.terraform_subnet_public_03.id,
      aws_subnet.terraform_subnet_private_01.id,
      aws_subnet.terraform_subnet_private_02.id,
      aws_subnet.terraform_subnet_private_03.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.terraform-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.terraform-AmazonEKSClusterPolicy,
  ]
}

resource "aws_eks_node_group" "terraform_node_group" {
  provider = aws.main
  cluster_name    = aws_eks_cluster.terraform_eks_cluster.name
  node_group_name = local.eks_options.node_group_name
  instance_types = local.eks_options.instance_types
  node_role_arn   = aws_iam_role.terraform_node_group_eks_iam_role.arn
  subnet_ids      = [
      aws_subnet.terraform_subnet_public_01.id,
      aws_subnet.terraform_subnet_public_02.id,
      aws_subnet.terraform_subnet_public_03.id,
    ]

  scaling_config {
    desired_size = local.eks_options.scaling_config.desired_size
    max_size     = local.eks_options.scaling_config.max_size
    min_size     = local.eks_options.scaling_config.min_size
  }

  update_config {
    max_unavailable = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.terraform_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.terraform_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.terraform_AmazonEC2ContainerRegistryReadOnly,
  ]
}
