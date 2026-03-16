variable "name" {
  description = "Base name for the dashboard"
  type        = string
}

variable "cloudwatch_namespace" {
  description = "CloudWatch namespace where k6 metrics are published (e.g. 'k6/my-app')"
  type        = string
}

variable "region" {
  description = "AWS region for the dashboard widgets"
  type        = string
}

variable "period" {
  description = "Default period in seconds for dashboard widgets"
  type        = number
  default     = 60
}

variable "metric_prefix" {
  description = "Prefix for k6 metric names (matches K6_STATSD_NAMESPACE)"
  type        = string
  default     = "k6."
}

variable "log_group_name" {
  description = "CloudWatch Log Group name for an optional Logs Insights widget"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for the dashboard (reserved for future use)"
  type        = map(string)
  default     = {}
}
