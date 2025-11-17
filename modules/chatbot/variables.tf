variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "slack_workspace_id" {
  description = "Slack workspace ID (team ID)"
  type        = string
}

variable "slack_channel_id" {
  description = "Slack channel ID where notifications will be sent"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic to subscribe to"
  type        = string
}

variable "logging_level" {
  description = "Logging level for AWS Chatbot (ERROR, INFO, NONE)"
  type        = string
  default     = "ERROR"
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}
