output "alb_dns_name" {
  description = "DNS p\u00fablico do ALB"
  value       = aws_lb.app.dns_name
}

output "asg_aza_name" {
  description = "Nome do ASG em AZ-A"
  value       = aws_autoscaling_group.aza.name
}

output "asg_azb_name" {
  description = "Nome do ASG em AZ-B"
  value       = aws_autoscaling_group.azb.name
}