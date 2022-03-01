# EKS IAM role
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.app_name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name = "${var.app_name}-iam-role"
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# Attach policy that allows EKS to make calls to other services
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Attach policy that allows security groups for pods
resource "aws_iam_role_policy_attachment" "eks_vpc_resource_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

# Create EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name = "${var.app_name}-cluster"
  role_arn =  aws_iam_role.eks_cluster_role.arn

  vpc_config {
   subnet_ids = var.private_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_policy,
  ]

  tags = {
    Name = "${var.app_name}-eks"
  }

}

# CloudWatch logs for cluster
resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.app_name}-logs"

  tags = {
    Application = var.app_name
  }
}