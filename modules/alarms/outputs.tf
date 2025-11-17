output "disk_usage_alarm_id" {
  description = "ID of the disk usage CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.disk_usage.id
}

output "disk_usage_alarm_arn" {
  description = "ARN of the disk usage CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.disk_usage.arn
}
