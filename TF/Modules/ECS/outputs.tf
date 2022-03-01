output "ecs_cluster" {
    description = "ECS cluster resource"
    value       = aws_ecs_cluster.aws-ecs-cluster
}

output "ecs_task_role" {
    description = "IAM role used to pull ECR images"
    value       = aws_iam_role.ecsTaskExecutionRole
}

output "cloudwatch_log_group" {
    description = "CloudWatch logs resource"
    value       = aws_cloudwatch_log_group.log-group
}
