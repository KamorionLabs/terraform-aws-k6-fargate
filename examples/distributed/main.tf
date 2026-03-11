module "k6" {
  source = "../../"

  name        = "my-app-loadtest-distributed"
  vpc_id      = "vpc-xxxxxxxx"
  subnet_ids  = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
  cluster_arn = "arn:aws:ecs:eu-west-3:123456789012:cluster/my-cluster"
  k6_image    = "ghcr.io/kamorionlabs/terraform-aws-k6-fargate:1.0.0"

  # Distributed testing: 5 tasks, more resources per task
  task_count = 5
  cpu        = 2048
  memory     = 4096

  # Custom namespace for this test scenario
  cloudwatch_namespace = "k6/my-app/stress-test"

  # Pass k6 options via environment
  extra_env_vars = {
    K6_VUS      = "100"
    K6_DURATION = "5m"
    TARGET_URL  = "https://api.example.com"
  }

  # Allow more dimensions for detailed analysis
  tag_blocklist = "vu,iter"

  tags = {
    Team    = "platform"
    Purpose = "load-testing"
  }
}

output "run_command" {
  value = module.k6.run_task_command
}
