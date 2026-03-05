# ---- Rede ----
variable "region" {
  description = "Regi\u00e3o AWS"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_pub_aza_cidr" {
  description = "CIDR da subnet p\u00fablica AZ-A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_pub_azb_cidr" {
  description = "CIDR da subnet p\u00fablica AZ-B"
  type        = string
  default     = "10.0.2.0/24"
}
variable "subnet_priv_aza_cidr" {
  description = "CIDR da subnet privada AZ-A"
  type        = string
  default     = "10.0.3.0/24"
}

variable "subnet_priv_azb_cidr" {
  description = "CIDR da subnet privada AZ-B"
  type        = string
  default     = "10.0.4.0/24"
}
# ---- Certificado ----
variable "domain_name" {
  description = "Domínio principal (ex: zenon.com.br) — usado no certificado ACM"
  type        = string
}

# ---- Compute ----
variable "ami_id" {
  description = "AMI Amazon Linux 2 (us-east-1)"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "Tipo de inst\u00e2ncia EC2"
  type        = string
  default     = "t3.micro"
}

variable "asg_min" {
  description = "M\u00ednimo de inst\u00e2ncias por ASG"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "M\u00e1ximo de inst\u00e2ncias por ASG"
  type        = number
  default     = 3
}

variable "asg_desired" {
  description = "Quantidade desejada de inst\u00e2ncias por ASG"
  type        = number
  default     = 1
}