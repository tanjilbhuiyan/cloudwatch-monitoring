# SSM Parameter to store CloudWatch Agent configuration
resource "aws_ssm_parameter" "cloudwatch_config" {
  name        = var.cloudwatch_agent_ssm_parameter_name
  description = "CloudWatch Agent configuration for disk monitoring"
  type        = "String"
  value       = file("${path.root}/cloudwatch_agent_config.json")

  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-cw-agent-config"
    }
  )
}

# SSM Document to install and configure CloudWatch Agent
resource "aws_ssm_document" "install_and_configure_cw_agent" {
  name            = "${var.resource_prefix}-InstallAndConfigureCloudWatchAgent"
  document_type   = "Command"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Install collectd, CloudWatch agent, push config, start agent"
    mainSteps = [

      # Step 1: Install collectd
      {
        action = "aws:runShellScript"
        name   = "installCollectd"
        inputs = {
          runCommand = [
            "sudo yum install -y collectd"
          ]
        }
      },

      # Step 2: Install CloudWatch agent package
      {
        action = "aws:configurePackage"
        name   = "installCWAgent"
        inputs = {
          name   = "AmazonCloudWatchAgent"
          action = "Install"
        }
      },

      # Step 3: Fetch config from SSM Parameter Store and write to file
      {
        action = "aws:runShellScript"
        name   = "writeConfig"
        inputs = {
          runCommand = [
            "sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/",
            "aws ssm get-parameter --name '${var.cloudwatch_agent_ssm_parameter_name}' --query 'Parameter.Value' --output text | sudo tee /opt/aws/amazon-cloudwatch-agent/etc/config.json > /dev/null"
          ]
        }
      },

      # Step 4: Run amazon-cloudwatch-agent-ctl to start with config
      {
        action = "aws:runShellScript"
        name   = "startCWAgent"
        inputs = {
          runCommand = [
            "sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json",
            "sudo systemctl enable amazon-cloudwatch-agent",
            "sudo systemctl start amazon-cloudwatch-agent"
          ]
        }
      }

    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-install-configure-cw-agent"
    }
  )
}

# SSM Association to install and configure CloudWatch Agent on tagged instances
resource "aws_ssm_association" "install_configure_agent" {
  name = aws_ssm_document.install_and_configure_cw_agent.name

  targets {
    key    = "tag:${var.instance_tag_key}"
    values = [var.instance_tag_value]
  }

  max_concurrency     = var.max_concurrency
  max_errors          = "${var.max_error_percentage}%"
  compliance_severity = "MEDIUM"

  depends_on = [aws_ssm_parameter.cloudwatch_config]
}
