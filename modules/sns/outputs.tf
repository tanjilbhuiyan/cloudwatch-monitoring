output "sns_topic_arn" {
  description = "ARN of the SNS topic for disk alerts"
  value       = aws_sns_topic.disk_alerts.arn
}

output "sns_topic_name" {
  description = "Name of the SNS topic for disk alerts"
  value       = aws_sns_topic.disk_alerts.name
}

output "sns_topic_id" {
  description = "ID of the SNS topic for disk alerts"
  value       = aws_sns_topic.disk_alerts.id
}
