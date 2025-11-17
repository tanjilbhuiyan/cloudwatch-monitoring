# IAM Role for AWS Chatbot
resource "aws_iam_role" "chatbot_role" {
  name = "${var.resource_prefix}-chatbot-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "chatbot.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-chatbot-role"
    }
  )
}

# IAM Policy for CloudWatch Read permissions
resource "aws_iam_role_policy" "chatbot_policy" {
  name = "${var.resource_prefix}-chatbot-policy"
  role = aws_iam_role.chatbot_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*"
        ]
        Resource = "*"
      }
    ]
  })
}

# AWS Chatbot Slack Channel Configuration
resource "aws_chatbot_slack_channel_configuration" "slack_notifications" {
  configuration_name = "${var.resource_prefix}-slack-notifications"
  iam_role_arn       = aws_iam_role.chatbot_role.arn
  slack_channel_id   = var.slack_channel_id
  slack_team_id      = var.slack_workspace_id
  logging_level      = var.logging_level

  sns_topic_arns = [var.sns_topic_arn]

  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-slack-chatbot"
    }
  )
}
