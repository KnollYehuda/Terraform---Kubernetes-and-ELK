resource "aws_iam_role" "terraform_eks_iam_role" {
  provider = aws.main
  name = local.eks_options.eks_iam_role.name

  assume_role_policy = <<POLICY
${local.eks_options.eks_iam_role.policy}
  POLICY
}

resource "aws_iam_role_policy_attachment" "terraform-AmazonEKSClusterPolicy" {
  provider = aws.main
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.terraform_eks_iam_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  provider = aws.main
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.terraform_eks_iam_role.name
}

resource "aws_iam_role" "terraform_node_group_eks_iam_role" {
  provider = aws.main
  name = local.eks_options.node_group_iam_role.name

  assume_role_policy = <<Policy
${local.eks_options.node_group_iam_role.policy}
  Policy
}

resource "aws_iam_role_policy_attachment" "terraform_AmazonEKSWorkerNodePolicy" {
  provider = aws.main
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.terraform_node_group_eks_iam_role.name
}

resource "aws_iam_role_policy_attachment" "terraform_AmazonEKS_CNI_Policy" {
  provider = aws.main
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.terraform_node_group_eks_iam_role.name
}

resource "aws_iam_role_policy_attachment" "terraform_AmazonEC2ContainerRegistryReadOnly" {
  provider = aws.main
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.terraform_node_group_eks_iam_role.name
}