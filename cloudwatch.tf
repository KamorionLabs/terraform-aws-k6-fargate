resource "aws_cloudwatch_log_group" "k6" {
  name              = "/ecs/${var.name}/k6"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.name}-k6-logs"
  })
}
