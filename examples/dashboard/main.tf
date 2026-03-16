module "k6" {
  source = "../../"

  name        = "my-app-loadtest"
  vpc_id      = "vpc-xxxxxxxx"
  subnet_ids  = ["subnet-xxxxxxxx"]
  cluster_arn = "arn:aws:ecs:eu-west-3:123456789012:cluster/my-cluster"
  k6_image    = "ghcr.io/kamorionlabs/terraform-aws-k6-fargate:1.0.0"

  # Enable CloudWatch dashboard
  enable_dashboard = true
  dashboard_period = 60
  metric_prefix    = "k6."

  # Enable Grafana Cloud streaming (optional)
  enable_grafana_cloud           = true
  grafana_cloud_token_secret_arn = "arn:aws:secretsmanager:eu-west-3:123456789012:secret:k6-grafana-cloud-token-AbCdEf"
}

output "run_command" {
  value = module.k6.run_task_command
}

output "scripts_bucket" {
  value = module.k6.scripts_bucket_name
}

output "dashboard_name" {
  value = module.k6.dashboard_name
}

output "dashboard_url" {
  description = "Direct link to the CloudWatch dashboard"
  value       = "https://eu-west-3.console.aws.amazon.com/cloudwatch/home?region=eu-west-3#dashboards:name=${module.k6.dashboard_name}"
}
