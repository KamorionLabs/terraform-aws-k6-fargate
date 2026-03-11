resource "aws_ssm_parameter" "cw_agent_config" {
  name = "/${var.name}/k6/cwagent-config"
  type = "String"

  value = jsonencode({
    metrics = {
      namespace = local.cloudwatch_namespace
      metrics_collected = {
        statsd = {
          service_address              = ":8125"
          metrics_collection_interval  = 1
          metrics_aggregation_interval = 0
        }
      }
    }
  })

  tags = merge(var.tags, {
    Name = "${var.name}-k6-cwagent-config"
  })
}
