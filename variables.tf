variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile name"
  type        = string
  default     = "staging"
}

# EC2 Instance Configuration
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0cae6d6fe6048ca2c"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
  default     = "subnet-0ef5c1cbef7c578ec"
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "allow_ssh" {
  description = "Whether to allow SSH access to the EC2 instance"
  type        = bool
  default     = true
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_name" {
  description = "SSH key pair name for the EC2 instance"
  type        = string
  default     = "test-nv"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "Monitor"
}

variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "ec2-disk-monitor"
}

variable "instance_tag_key" {
  description = "Tag key used to select instances to monitor"
  type        = string
  default     = "Name"
}

variable "instance_tag_value" {
  description = "Tag value used to select instances to monitor"
  type        = string
  default     = "Monitor"
}

variable "cloudwatch_agent_ssm_parameter_name" {
  description = "SSM parameter name to store CloudWatch Agent config"
  type        = string
  default     = "/AmazonCloudWatch/linux/config"
}

variable "threshold_percent" {
  description = "Disk usage threshold percent to trigger alarm"
  type        = number
  default     = 10
}

variable "period_seconds" {
  description = "Period (seconds) for metric evaluation"
  type        = number
  default     = 60
}

variable "evaluation_periods" {
  description = "Number of evaluation periods for alarm"
  type        = number
  default     = 2
}

variable "slack_workspace_id" {
  description = "Slack workspace id for AWS Chatbot"
  type        = string
  default     = ""
}

variable "slack_channel_id" {
  description = "Slack channel id for AWS Chatbot"
  type        = string
  default     = ""
}

variable "chatbot_logging_level" {
  description = "Logging level for AWS Chatbot (ERROR | INFO)"
  type        = string
  default     = "ERROR"
}

variable "agent_max_concurrency" {
  description = "Max concurrency for SSM association"
  type        = string
  default     = "5"
}

variable "agent_max_error_percentage" {
  description = "Max error percentage for SSM association"
  type        = number
  default     = 10
}

variable "email_endpoint" {
  description = "Email address for SNS notifications"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags to apply"
  type        = map(string)
  default     = {}
}
