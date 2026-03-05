variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_pub_aza_cidr" {
  description = "CIDR block for the public subnet in AZ A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_pub_azb_cidr" {
  description = "CIDR block for the public subnet in AZ B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet_priv_aza_cidr" {
  description = "CIDR block for the private subnet in AZ A"
  type        = string
  default     = "10.0.3.0/24"
}

variable "subnet_priv_azb_cidr" {
  description = "CIDR block for the private subnet in AZ B"
  type        = string
  default     = "10.0.4.0/24"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}