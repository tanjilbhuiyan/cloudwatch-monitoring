# SNS Topic for CloudWatch Alarms
resource "aws_sns_topic" "disk_alerts" {
  name = "${var.resource_prefix}-disk-alerts"

  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-disk-alerts"
    }
  )
}

# SNS Topic Subscription (Email)
# Note: Email subscriptions require manual confirmation
resource "aws_sns_topic_subscription" "disk_alerts_email" {
  count     = var.email_endpoint != "" ? 1 : 0
  topic_arn = aws_sns_topic.disk_alerts.arn
  protocol  = "email"
  endpoint  = var.email_endpoint
}

# SNS Topic Policy (optional - allows CloudWatch to publish)
resource "aws_sns_topic_policy" "disk_alerts_policy" {
  arn = aws_sns_topic.disk_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action = [
          "SNS:Publish"
        ]
        Resource = aws_sns_topic.disk_alerts.arn
      }
    ]
  })
}
