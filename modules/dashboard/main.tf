resource "aws_cloudwatch_dashboard" "k6" {
  dashboard_name = "${var.name}-k6-results"
  dashboard_body = templatefile("${path.module}/templates/dashboard.json.tftpl", {
    namespace     = var.cloudwatch_namespace
    region        = var.region
    period        = var.period
    metric_prefix = var.metric_prefix
  })
}
