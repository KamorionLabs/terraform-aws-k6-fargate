data "aws_region" "current" {}

# -----------------------------------------------------------------------------
# Container Definitions
# -----------------------------------------------------------------------------

locals {
  base_env_vars = [
    { name = "K6_STATSD_ADDR", value = "localhost:8125" },
    { name = "K6_STATSD_ENABLE_TAGS", value = "true" },
    { name = "K6_STATSD_TAG_BLOCKLIST", value = var.tag_blocklist },
    { name = "K6_STATSD_NAMESPACE", value = "k6." },
    { name = "K6_STATSD_PUSH_INTERVAL", value = "1s" },
    { name = "K6_SCRIPTS_BUCKET", value = aws_s3_bucket.scripts.id },
    { name = "K6_SCRIPTS_PREFIX", value = var.k6_scripts_prefix },
    { name = "K6_SCRIPT", value = var.k6_script },
  ]

  extra_env_list = [for k, v in var.extra_env_vars : { name = k, value = v }]
  k6_env_vars    = concat(local.base_env_vars, local.extra_env_list)

  container_definitions = [
    {
      name      = "k6"
      image     = var.k6_image
      essential = true

      dependsOn = [
        {
          containerName = "cloudwatch-agent"
          condition     = "HEALTHY"
        }
      ]

      environment = local.k6_env_vars

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.k6.name
          "awslogs-region"        = data.aws_region.current.id
          "awslogs-stream-prefix" = "k6"
        }
      }
    },
    {
      name      = "cloudwatch-agent"
      image     = "public.ecr.aws/cloudwatch-agent/cloudwatch-agent:latest"
      essential = false

      healthCheck = {
        command     = ["CMD-SHELL", "/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status | grep -q running"]
        interval    = 5
        timeout     = 3
        retries     = 3
        startPeriod = 10
      }

      secrets = [
        {
          name      = "CW_CONFIG_CONTENT"
          valueFrom = aws_ssm_parameter.cw_agent_config.arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.k6.name
          "awslogs-region"        = data.aws_region.current.id
          "awslogs-stream-prefix" = "cloudwatch-agent"
        }
      }
    }
  ]
}

# -----------------------------------------------------------------------------
# ECS Task Definition
# -----------------------------------------------------------------------------

resource "aws_ecs_task_definition" "k6" {
  family                   = "${var.name}-k6"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = tostring(var.cpu)
  memory                   = tostring(var.memory)
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = var.runtime_platform
  }

  container_definitions = jsonencode(local.container_definitions)

  tags = var.tags
}
