output "ssm_parameter_name" {
  description = "Name of the SSM parameter storing CloudWatch Agent configuration"
  value       = aws_ssm_parameter.cloudwatch_config.name
}

output "ssm_parameter_arn" {
  description = "ARN of the SSM parameter storing CloudWatch Agent configuration"
  value       = aws_ssm_parameter.cloudwatch_config.arn
}

output "install_document_name" {
  description = "Name of the SSM document for installing and configuring CloudWatch Agent"
  value       = aws_ssm_document.install_and_configure_cw_agent.name
}

output "install_association_id" {
  description = "ID of the SSM association for installing and configuring CloudWatch Agent"
  value       = aws_ssm_association.install_configure_agent.id
}
