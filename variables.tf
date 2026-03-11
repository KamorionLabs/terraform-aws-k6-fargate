# -----------------------------------------------------------------------------
# Required Variables
# -----------------------------------------------------------------------------

variable "name" {
  description = "Base name for all resources (e.g. 'homebox-staging-loadtest')"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for ECS tasks (private subnets with NAT recommended)"
  type        = list(string)
}

variable "cluster_arn" {
  description = "ECS cluster ARN to run tasks on"
  type        = string
}

variable "k6_image" {
  description = "Docker image URI for the custom k6 image (e.g. 'ghcr.io/kamorionlabs/terraform-aws-k6-fargate:1.0.0')"
  type        = string
}

# -----------------------------------------------------------------------------
# Optional Variables - Task Configuration
# -----------------------------------------------------------------------------

variable "k6_script" {
  description = "Name of the k6 script file to run"
  type        = string
  default     = "test.js"
}

variable "k6_scripts_prefix" {
  description = "S3 prefix for k6 scripts"
  type        = string
  default     = "scripts/"
}

variable "cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 1024
}

variable "memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 2048
}

variable "task_count" {
  description = "Number of tasks for distributed testing"
  type        = number
  default     = 1
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks (true if no NAT)"
  type        = bool
  default     = false
}

variable "runtime_platform" {
  description = "CPU architecture. Valid values: ARM64 or X86_64"
  type        = string
  default     = "ARM64"

  validation {
    condition     = contains(["ARM64", "X86_64"], var.runtime_platform)
    error_message = "runtime_platform must be either ARM64 or X86_64."
  }
}

# -----------------------------------------------------------------------------
# Optional Variables - Observability
# -----------------------------------------------------------------------------

variable "cloudwatch_namespace" {
  description = "CloudWatch namespace for metrics. If null, defaults to 'k6/{var.name}'"
  type        = string
  default     = null
}

variable "log_retention_days" {
  description = "CloudWatch Log Group retention in days"
  type        = number
  default     = 14
}

variable "tag_blocklist" {
  description = "k6 StatsD tag blocklist for cost control (comma-separated). Blocks high-cardinality dimensions."
  type        = string
  default     = "url,name,vu,iter,scenario,expected_response,group"
}

# -----------------------------------------------------------------------------
# Optional Variables - Passthrough
# -----------------------------------------------------------------------------

variable "extra_env_vars" {
  description = "Additional environment variables to pass to the k6 container (K6_VUS, K6_DURATION, TARGET_URL, etc.)"
  type        = map(string)
  default     = {}
}

# -----------------------------------------------------------------------------
# Optional Variables - Tagging
# -----------------------------------------------------------------------------

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
