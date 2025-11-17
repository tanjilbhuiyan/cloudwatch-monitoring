output "chatbot_name" {
  description = "Name of the AWS Chatbot Slack channel configuration"
  value       = aws_chatbot_slack_channel_configuration.slack_notifications.configuration_name
}

output "chatbot_arn" {
  description = "ARN of the AWS Chatbot Slack channel configuration"
  value       = aws_chatbot_slack_channel_configuration.slack_notifications.chat_configuration_arn
}

output "chatbot_role_arn" {
  description = "ARN of the IAM role used by AWS Chatbot"
  value       = aws_iam_role.chatbot_role.arn
}

output "chatbot_role_name" {
  description = "Name of the IAM role used by AWS Chatbot"
  value       = aws_iam_role.chatbot_role.name
}
