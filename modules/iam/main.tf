# IAM Role for EC2 Instance
resource "aws_iam_role" "ec2_cloudwatch_ssm_role" {
  name = "${var.resource_prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-ec2-role"
    }
  )
}

# Attach AWS Managed Policy for SSM
resource "aws_iam_role_policy_attachment" "ssm_managed_policy" {
  role       = aws_iam_role.ec2_cloudwatch_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach AWS Managed Policy for CloudWatch Agent Server
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy" {
  role       = aws_iam_role.ec2_cloudwatch_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Additional inline policy for SSM Parameter Store access (if needed)
resource "aws_iam_role_policy" "ssm_parameter_access" {
  name = "${var.resource_prefix}-ssm-parameter-access"
  role = aws_iam_role.ec2_cloudwatch_ssm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:PutParameter"
        ]
        Resource = "arn:aws:ssm:*:*:parameter/AmazonCloudWatch/*"
      }
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.resource_prefix}-instance-profile"
  role = aws_iam_role.ec2_cloudwatch_ssm_role.name

  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-instance-profile"
    }
  )
}
