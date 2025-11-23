# AWS Configuration
aws_region  = "us-east-1"
aws_profile = "default"

# EC2 Instance Configuration
ami_id        = "ami-0abcdef1234567890" # Example Amazon Linux 2 AMI
instance_type = "t3.micro"
subnet_id     = "subnet-0123456789abcdef0"
vpc_id        = "vpc-0123456789abcdef0"
key_name      = "my-ec2-keypair"
instance_name = "DiskMonitor"

# Security Group Configuration
allow_ssh       = true
ssh_cidr_blocks = "10.0.0.0/8" # Restrict to your private network

# Resource Naming
resource_prefix = "ec2-disk-monitor"

# Instance Tagging for SSM Association
instance_tag_key   = "Name"
instance_tag_value = "DiskMonitor"

# CloudWatch Agent Configuration
cloudwatch_agent_ssm_parameter_name = "/AmazonCloudWatch/linux/config"

# Alarm Thresholds
threshold_percent  = 80  # Alert when disk usage exceeds 80%
period_seconds     = 300 # 5 minutes evaluation period
evaluation_periods = 2   # Number of consecutive periods before alarming

# SNS Notification
email_endpoint = "alerts@example.com" # Email address for alarm notifications

# SSM Association Settings
agent_max_concurrency      = "5"
agent_max_error_percentage = 10

# Slack Configuration (Optional - leave empty if not using)
slack_workspace_id    = "T01234567AB" # Replace with your Slack workspace ID (starts with T)
slack_channel_id      = "C01234567AB" # Replace with your Slack channel ID (starts with C)
chatbot_logging_level = "ERROR"

# Common Tags
tags = {
  Environment = "development"
  ManagedBy   = "terraform"
  Project     = "disk-monitoring"
  Owner       = "infrastructure-team"
  CostCenter  = "engineering"
}
