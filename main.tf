terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # profile = var.aws_profile
}

module "iam" {
  source = "./modules/iam"

  resource_prefix = var.resource_prefix
  tags            = var.tags
}

module "security_group" {
  source = "./modules/security_group"

  resource_prefix = var.resource_prefix
  vpc_id          = var.vpc_id
  allow_ssh       = var.allow_ssh
  ssh_cidr_blocks = var.ssh_cidr_blocks
  tags            = var.tags
}

module "ec2" {
  source = "./modules/ec2"

  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  subnet_id                 = var.subnet_id
  iam_instance_profile_name = module.iam.instance_profile_name
  security_group_ids        = [module.security_group.security_group_id]
  key_name                  = var.key_name
  instance_name             = var.instance_name
  tags                      = var.tags
}

module "agent" {
  source = "./modules/agent"

  resource_prefix                     = var.resource_prefix
  instance_tag_key                    = var.instance_tag_key
  instance_tag_value                  = var.instance_tag_value
  cloudwatch_agent_ssm_parameter_name = var.cloudwatch_agent_ssm_parameter_name
  max_concurrency                     = var.agent_max_concurrency
  max_error_percentage                = var.agent_max_error_percentage
  tags                                = var.tags

  depends_on = [module.ec2]
}

module "sns" {
  source = "./modules/sns"

  resource_prefix = var.resource_prefix
  email_endpoint  = var.email_endpoint
  tags            = var.tags
}

module "alarms" {
  source             = "./modules/alarms"
  resource_prefix    = var.resource_prefix
  threshold_percent  = var.threshold_percent
  period_seconds     = var.period_seconds
  evaluation_periods = var.evaluation_periods

  instance_id   = module.ec2.instance_id
  sns_topic_arn = module.sns.sns_topic_arn
  tags          = var.tags

  depends_on = [module.agent]
}

module "chatbot" {
  source = "./modules/chatbot"

  resource_prefix    = var.resource_prefix
  slack_workspace_id = var.slack_workspace_id
  slack_channel_id   = var.slack_channel_id
  sns_topic_arn      = module.sns.sns_topic_arn
  logging_level      = var.chatbot_logging_level
  tags               = var.tags
}
