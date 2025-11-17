output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2.instance_private_ip
}

output "ec2_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.instance_public_ip
}

output "ssm_parameter_name" {
  description = "SSM parameter storing CloudWatch Agent configuration"
  value       = module.agent.ssm_parameter_name
}

output "sns_topic_arn" {
  description = "SNS topic ARN for disk alerts"
  value       = module.sns.sns_topic_arn
}

output "ec2_instance_profile" {
  description = "IAM instance profile name to attach to EC2 instances"
  value       = module.iam.instance_profile_name
}

output "disk_usage_alarm_id" {
  description = "ID of the disk usage CloudWatch alarm"
  value       = module.alarms.disk_usage_alarm_id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.security_group.security_group_id
}

output "chatbot_configuration_name" {
  description = "AWS Chatbot Slack channel configuration name"
  value       = module.chatbot.chatbot_name
}
