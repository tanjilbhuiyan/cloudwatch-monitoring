```markdown
# EC2 Disk Monitoring (modular Terraform)

This repository implements EC2 disk monitoring using CloudWatch Agent, CloudWatch Alarms, SNS, and AWS Chatbot — all organized into reusable Terraform modules.

Modules:
- modules/agent: Deploys CloudWatch Agent config into SSM Parameter Store and creates an SSM Association using the AWS-managed document to configure the agent on instances selected by tag.
- modules/iam: Creates an IAM Role and Instance Profile for EC2 (SSM + CloudWatchAgent permissions).
- modules/sns: Creates an SNS topic for alerts.
- modules/alarms: Creates per-instance CloudWatch alarms for disk_used_percent (namespace CWAgent).
- modules/chatbot: Creates AWS Chatbot Slack channel configuration and role to forward SNS notifications to Slack.

Quick usage:
1. Populate variables (e.g., slack_workspace_id & slack_channel_id) via terraform.tfvars or CLI.
2. Ensure EC2 instances to be monitored are tagged (default: Monitor=true).
3. Attach the generated instance profile (module.iam.instance_profile_name) to instances, or ensure instances have equivalent IAM permissions.
4. terraform init && terraform apply

Notes:
- Instances must run SSM Agent and allow SSM in network path (if private subnets ensure SSM endpoints or NAT).
- CloudWatch Agent config is in modules/agent/cloudwatch_agent_config.json; extend it to collect logs or extra metrics if desired.
- For debugging, enable CloudWatch Logs in the agent config and set chatbot_logging_level to INFO.

```