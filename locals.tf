locals {
  cloudwatch_namespace = var.cloudwatch_namespace != null ? var.cloudwatch_namespace : "k6/${var.name}"
}
