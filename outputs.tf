output "task_definition_arn" {
  description = "ARN of the k6 ECS task definition"
  value       = aws_ecs_task_definition.k6.arn
}

output "task_definition_family" {
  description = "Family of the k6 ECS task definition"
  value       = aws_ecs_task_definition.k6.family
}

output "scripts_bucket_name" {
  description = "Name of the S3 bucket for k6 scripts"
  value       = aws_s3_bucket.scripts.id
}

output "scripts_bucket_arn" {
  description = "ARN of the S3 bucket for k6 scripts"
  value       = aws_s3_bucket.scripts.arn
}

output "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.k6.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.k6.arn
}

output "security_group_id" {
  description = "ID of the k6 task security group"
  value       = aws_security_group.k6.id
}

output "execution_role_arn" {
  description = "ARN of the ECS execution role"
  value       = aws_iam_role.execution.arn
}

output "task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.task.arn
}

output "cloudwatch_namespace" {
  description = "CloudWatch namespace for k6 metrics"
  value       = local.cloudwatch_namespace
}

output "run_task_command" {
  description = "AWS CLI command to run a k6 load test. Replace K6_SCRIPT, K6_VUS, and K6_DURATION values as needed."
  value       = <<-EOT
    aws ecs run-task \
      --cluster ${var.cluster_arn} \
      --task-definition ${aws_ecs_task_definition.k6.arn} \
      --count ${var.task_count} \
      --launch-type FARGATE \
      --network-configuration '{"awsvpcConfiguration":{"subnets":${jsonencode(var.subnet_ids)},"securityGroups":["${aws_security_group.k6.id}"],"assignPublicIp":"${var.assign_public_ip ? "ENABLED" : "DISABLED"}"}}' \
      --overrides '{"containerOverrides":[{"name":"k6","environment":[{"name":"K6_SCRIPT","value":"YOUR_SCRIPT.js"},{"name":"K6_VUS","value":"10"},{"name":"K6_DURATION","value":"30s"}]}]}'
  EOT
}
