# Security Group for EC2 Instance
resource "aws_security_group" "ec2_sg" {
  name        = "${var.resource_prefix}-ec2-sg"
  description = "Security group for EC2 instance with CloudWatch monitoring"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.resource_prefix}-ec2-sg"
    }
  )
}

# SSH Ingress Rule (optional, controlled by variable)
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  count             = var.allow_ssh ? 1 : 0
  security_group_id = aws_security_group.ec2_sg.id

  description = "Allow SSH access"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = var.ssh_cidr_blocks
}

# HTTPS Egress for SSM, CloudWatch, and AWS APIs
resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.ec2_sg.id

  description = "Allow HTTPS outbound for AWS services (SSM, CloudWatch, etc.)"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

# HTTP Egress for package downloads (yum/apt)
resource "aws_vpc_security_group_egress_rule" "http" {
  security_group_id = aws_security_group.ec2_sg.id

  description = "Allow HTTP outbound for package downloads"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

# DNS Egress
resource "aws_vpc_security_group_egress_rule" "dns_tcp" {
  security_group_id = aws_security_group.ec2_sg.id

  description = "Allow DNS TCP"
  from_port   = 53
  to_port     = 53
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "dns_udp" {
  security_group_id = aws_security_group.ec2_sg.id

  description = "Allow DNS UDP"
  from_port   = 53
  to_port     = 53
  ip_protocol = "udp"
  cidr_ipv4   = "0.0.0.0/0"
}
