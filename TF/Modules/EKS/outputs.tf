output "eks_cluster" {
    description = "EKS cluster resource"
    value       = aws_eks_cluster.eks_cluster
}

output "eks_role" {
    description = "IAM role used to allow EKS to manage resources"
    value       = aws_iam_role.eks_cluster_role
}

output "cloudwatch_log_group" {
    description = "CloudWatch logs resource"
    value       = aws_cloudwatch_log_group.log-group
}
