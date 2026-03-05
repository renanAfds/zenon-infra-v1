output "vpc_id" {
  description = "ID da VPC principal"
  value       = aws_vpc.main.id
}

output "subnet_aza_id" {
  description = "ID da subnet pública em AZ-A"
  value       = aws_subnet.public_aza.id
}

output "subnet_azb_id" {
  description = "ID da subnet pública em AZ-B"
  value       = aws_subnet.public_azb.id
}

output "subnet_priv_aza_id" {
  description = "ID da subnet privada em AZ-A"
  value       = aws_subnet.private_aza.id
}

output "subnet_priv_azb_id" {
  description = "ID da subnet privada em AZ-B"
  value       = aws_subnet.private_azb.id
}

output "sg_alb_id" {
  description = "Security Group do ALB"
  value       = aws_security_group.alb.id
}

output "sg_ec2_id" {
  description = "Security Group das EC2"
  value       = aws_security_group.ec2.id
}