# CloudWatch Alarm for Disk Usage Percentage
resource "aws_cloudwatch_metric_alarm" "disk_usage" {
  alarm_name          = "${var.resource_prefix}-disk-usage-${var.instance_id}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = var.period_seconds
  statistic           = "Average"
  threshold           = var.threshold_percent
  alarm_description   = "Alert when disk usage exceeds ${var.threshold_percent}% on instance ${var.instance_id}"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = var.instance_id
    path       = "/"
    device     = "nvme0n1p1"
    fstype     = "xfs"
  }

  alarm_actions = [var.sns_topic_arn]

  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-disk-usage-alarm"
    }
  )
}
