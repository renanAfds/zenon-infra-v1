variable "domain_name" {
  description = "Domínio principal para o certificado ACM (ex: zenon.com.br)"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnet_aza_id" {
  description = "ID da subnet pública AZ-A (usada pelo ALB)"
  type        = string
}

variable "subnet_azb_id" {
  description = "ID da subnet pública AZ-B (usada pelo ALB)"
  type        = string
}

variable "subnet_priv_aza_id" {
  description = "ID da subnet privada AZ-A (usada pelo ASG)"
  type        = string
}

variable "subnet_priv_azb_id" {
  description = "ID da subnet privada AZ-B (usada pelo ASG)"
  type        = string
}

variable "sg_alb_id" {
  description = "Security Group do ALB"
  type        = string
}

variable "sg_ec2_id" {
  description = "Security Group das EC2"
  type        = string
}

variable "ami_id" {
  description = "AMI para as inst\u00e2ncias do ASG (Amazon Linux 2)"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2 us-east-1
}

variable "instance_type" {
  description = "Tipo de inst\u00e2ncia EC2"
  type        = string
  default     = "t3.micro"
}

variable "asg_min" {
  description = "N\u00famero m\u00ednimo de inst\u00e2ncias por ASG"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "N\u00famero m\u00e1ximo de inst\u00e2ncias por ASG"
  type        = number
  default     = 3
}

variable "asg_desired" {
  description = "N\u00famero desejado de inst\u00e2ncias por ASG"
  type        = number
  default     = 1
}