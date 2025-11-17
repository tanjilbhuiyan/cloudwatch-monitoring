variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "email_endpoint" {
  description = "Email address for SNS notifications"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}
