module "k6" {
  source = "../../"

  name        = "my-app-loadtest"
  vpc_id      = "vpc-xxxxxxxx"
  subnet_ids  = ["subnet-xxxxxxxx"]
  cluster_arn = "arn:aws:ecs:eu-west-3:123456789012:cluster/my-cluster"
  k6_image    = "ghcr.io/kamorionlabs/terraform-aws-k6-fargate:1.0.0"
}

output "run_command" {
  value = module.k6.run_task_command
}

output "scripts_bucket" {
  value = module.k6.scripts_bucket_name
}
