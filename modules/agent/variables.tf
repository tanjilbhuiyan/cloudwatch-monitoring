variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "instance_tag_key" {
  description = "Tag key used to select instances to monitor"
  type        = string
}

variable "instance_tag_value" {
  description = "Tag value used to select instances to monitor"
  type        = string
}

variable "cloudwatch_agent_ssm_parameter_name" {
  description = "SSM parameter name to store CloudWatch Agent config"
  type        = string
}

variable "max_concurrency" {
  description = "Max concurrency for SSM association"
  type        = string
  default     = "5"
}

variable "max_error_percentage" {
  description = "Max error percentage for SSM association"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}
