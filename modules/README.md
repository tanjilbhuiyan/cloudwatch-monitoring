# Terraform Modules Documentation

This directory contains reusable Terraform modules for setting up EC2 monitoring with CloudWatch Agent and SSM.

## Module Structure

### 1. IAM Module (`iam/`)

Creates IAM roles and instance profiles required for EC2 instances to interact with SSM and CloudWatch.

**Resources Created:**
- IAM Role with EC2 assume role policy
- IAM Instance Profile attached to the role
- AWS Managed Policy: `AmazonSSMManagedInstanceCore`
- AWS Managed Policy: `CloudWatchAgentServerPolicy`
- Inline policy for SSM Parameter Store access

**Inputs:**
- `resource_prefix`: Prefix for resource names
- `tags`: Common tags to apply

**Outputs:**
- `instance_profile_name`: Name of the IAM instance profile
- `instance_profile_arn`: ARN of the IAM instance profile
- `role_name`: Name of the IAM role
- `role_arn`: ARN of the IAM role

---

### 2. Agent Module (`agent/`)

Manages CloudWatch Agent installation and configuration using SSM documents and associations.

**Resources Created:**
- SSM Parameter storing CloudWatch Agent configuration
- SSM Document for installing and configuring CloudWatch Agent
- SSM Document for starting CloudWatch Agent
- SSM Associations to automatically apply documents to tagged instances

**Inputs:**
- `resource_prefix`: Prefix for resource names
- `instance_tag_key`: Tag key to target instances (e.g., "Name")
- `instance_tag_value`: Tag value to target instances (e.g., "Monitor")
- `cloudwatch_agent_ssm_parameter_name`: SSM parameter name for config storage
- `max_concurrency`: Maximum concurrent executions
- `max_error_percentage`: Maximum error percentage allowed
- `tags`: Common tags to apply

**Outputs:**
- `ssm_parameter_name`: SSM parameter storing the configuration
- `install_document_name`: Name of installation SSM document
- `start_document_name`: Name of start SSM document
- `install_association_id`: ID of installation association
- `start_association_id`: ID of start association

**How it works:**
1. Installs `collectd` for metrics collection
2. Installs CloudWatch Agent using `aws:configurePackage`
3. Fetches configuration from SSM Parameter Store
4. Starts the CloudWatch Agent service
5. Automatically applies to instances matching the specified tags

---

### 3. SNS Module (`sns/`)

Creates SNS topic for CloudWatch alarm notifications.

**Resources Created:**
- SNS Topic for alerts
- SNS Topic Subscription (optional email)
- SNS Topic Policy allowing CloudWatch to publish

**Inputs:**
- `resource_prefix`: Prefix for resource names
- `email_endpoint`: Email address for notifications (optional)
- `tags`: Common tags to apply

**Outputs:**
- `sns_topic_arn`: ARN of the SNS topic
- `sns_topic_name`: Name of the SNS topic
- `sns_topic_id`: ID of the SNS topic

**Note:** Email subscriptions require manual confirmation via the confirmation email sent by AWS.

---

### 4. Alarms Module (`alarms/`)

Creates CloudWatch alarms to monitor disk usage metrics.

**Resources Created:**
- CloudWatch Alarm for specific disk partition
- CloudWatch Alarm for all disks (uses Maximum statistic)

**Inputs:**
- `resource_prefix`: Prefix for resource names
- `instance_id`: EC2 instance ID to monitor
- `sns_topic_arn`: ARN of SNS topic for notifications
- `threshold_percent`: Disk usage threshold (default: 80%)
- `period_seconds`: Evaluation period in seconds (default: 300)
- `evaluation_periods`: Number of periods to evaluate (default: 2)
- `tags`: Common tags to apply

**Outputs:**
- `disk_usage_alarm_id`: ID of the specific disk alarm
- `disk_usage_alarm_arn`: ARN of the specific disk alarm
- `disk_usage_all_alarm_id`: ID of the all-disks alarm
- `disk_usage_all_alarm_arn`: ARN of the all-disks alarm

**Alarm Behavior:**
- Triggers when disk usage exceeds threshold
- Sends notification to SNS topic
- Sends OK notification when disk usage returns to normal
- Missing data is treated as "not breaching"

---

## Usage Example

```hcl
module "iam" {
  source = "./modules/iam"

  resource_prefix = "my-app"
  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

module "agent" {
  source = "./modules/agent"

  resource_prefix                     = "my-app"
  instance_tag_key                    = "Name"
  instance_tag_value                  = "Monitor"
  cloudwatch_agent_ssm_parameter_name = "/AmazonCloudWatch/linux/config"
  max_concurrency                     = "5"
  max_error_percentage                = 10
  tags = {
    Environment = "production"
  }
}

module "sns" {
  source = "./modules/sns"

  resource_prefix = "my-app"
  email_endpoint  = "alerts@example.com"
  tags = {
    Environment = "production"
  }
}

module "alarms" {
  source = "./modules/alarms"

  resource_prefix    = "my-app"
  instance_id        = aws_instance.my_instance.id
  sns_topic_arn      = module.sns.sns_topic_arn
  threshold_percent  = 85
  period_seconds     = 60
  evaluation_periods = 2
  tags = {
    Environment = "production"
  }
}
```

## Prerequisites

1. **EC2 Instance Requirements:**
   - Must have the IAM instance profile attached
   - Must be tagged appropriately for SSM associations
   - Must have network access to SSM and CloudWatch endpoints

2. **CloudWatch Agent Configuration:**
   - Configuration file should be in JSON format
   - Must be available at `cloudwatch_agent_config.json` in the root module

3. **AWS Permissions:**
   - Terraform execution role needs permissions to create IAM roles, SSM documents, SNS topics, and CloudWatch alarms

## Troubleshooting

### SSM Association Not Running
- Verify the EC2 instance has the correct tags
- Check that the instance is managed by SSM (appears in Fleet Manager)
- Ensure the IAM role has `AmazonSSMManagedInstanceCore` policy

### CloudWatch Metrics Not Appearing
- Verify CloudWatch Agent is running: `sudo systemctl status amazon-cloudwatch-agent`
- Check agent logs: `/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log`
- Verify IAM role has `CloudWatchAgentServerPolicy`

### Alarms Not Triggering
- Ensure metrics are being published to CloudWatch (check the Metrics console)
- Verify the metric dimensions match (InstanceId, path, device, fstype)
- Check alarm configuration and threshold values

## Additional Resources

- [CloudWatch Agent Configuration Reference](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)
- [SSM Documents](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-ssm-docs.html)
- [CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)