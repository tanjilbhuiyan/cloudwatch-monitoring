resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  iam_instance_profile = var.iam_instance_profile_name

  vpc_security_group_ids = var.security_group_ids

  key_name = var.key_name

  tags = merge(
    var.tags,
    {
      Name       = var.instance_name
      CloudWatch = "enabled"
    }
  )
}
