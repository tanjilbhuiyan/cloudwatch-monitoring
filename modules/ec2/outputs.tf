output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.ec2.arn
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ec2.private_ip
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = aws_instance.ec2.instance_state
}
