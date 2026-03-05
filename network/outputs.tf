output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "subnet_cidr" {
  value = aws_subnet.public.cidr_block
}