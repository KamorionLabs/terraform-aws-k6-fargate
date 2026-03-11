# -----------------------------------------------------------------------------
# Execution Role - Used by ECS agent to pull images, write logs, read SSM
# -----------------------------------------------------------------------------

resource "aws_iam_role" "execution" {
  name = "${var.name}-k6-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "execution_ecs" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "execution_ssm" {
  name = "${var.name}-k6-execution-ssm"
  role = aws_iam_role.execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["ssm:GetParameters", "ssm:GetParameter"]
      Resource = [aws_ssm_parameter.cw_agent_config.arn]
    }]
  })
}

# -----------------------------------------------------------------------------
# Task Role - Used by containers at runtime for S3, CW
# -----------------------------------------------------------------------------

resource "aws_iam_role" "task" {
  name = "${var.name}-k6-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "task_s3" {
  name = "${var.name}-k6-task-s3"
  role = aws_iam_role.task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:GetObject", "s3:ListBucket"]
      Resource = [
        aws_s3_bucket.scripts.arn,
        "${aws_s3_bucket.scripts.arn}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "task_cw_agent" {
  role       = aws_iam_role.task.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
