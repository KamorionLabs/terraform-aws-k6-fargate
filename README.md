# terraform-aws-k6-fargate

Terraform module to run k6 load tests on ECS Fargate with CloudWatch metrics.

[![Docker Hub](https://img.shields.io/docker/v/kamorionlabs/k6-fargate?label=Docker%20Hub&sort=semver)](https://hub.docker.com/r/kamorionlabs/k6-fargate)
[![GHCR](https://img.shields.io/badge/GHCR-ghcr.io%2Fkamorionlabs%2Fterraform--aws--k6--fargate-blue)](https://github.com/KamorionLabs/terraform-aws-k6-fargate/pkgs/container/terraform-aws-k6-fargate)

## Usage

```hcl
module "k6" {
  source = "KamorionLabs/k6-fargate/aws"

  name        = "my-load-test"
  vpc_id      = "vpc-abc123"
  subnet_ids  = ["subnet-abc123"]
  cluster_arn = "arn:aws:ecs:eu-west-3:123456789012:cluster/my-cluster"
  k6_image    = "kamorionlabs/k6-fargate:latest"
}
```

## License

Apache 2.0 - See [LICENSE](LICENSE) for details.
