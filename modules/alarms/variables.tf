variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID to monitor"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of SNS topic for alarm notifications"
  type        = string
}

variable "threshold_percent" {
  description = "Disk usage threshold percent to trigger alarm"
  type        = number
  default     = 80
}

variable "period_seconds" {
  description = "Period (seconds) for metric evaluation"
  type        = number
  default     = 300
}

variable "evaluation_periods" {
  description = "Number of evaluation periods for alarm"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}
