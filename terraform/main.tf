module "network" {
  source = "./network"

  vpc_cidr              = var.vpc_cidr
  subnet_pub_aza_cidr   = var.subnet_pub_aza_cidr
  subnet_pub_azb_cidr   = var.subnet_pub_azb_cidr
  subnet_priv_aza_cidr  = var.subnet_priv_aza_cidr
  subnet_priv_azb_cidr  = var.subnet_priv_azb_cidr
  region                = var.region
}

module "compute" {
  source = "./compute"

  vpc_id             = module.network.vpc_id
  subnet_aza_id      = module.network.subnet_aza_id      # ALB — pública
  subnet_azb_id      = module.network.subnet_azb_id      # ALB — pública
  subnet_priv_aza_id = module.network.subnet_priv_aza_id # ASG — privada
  subnet_priv_azb_id = module.network.subnet_priv_azb_id # ASG — privada
  sg_alb_id          = module.network.sg_alb_id
  sg_ec2_id          = module.network.sg_ec2_id

  domain_name   = var.domain_name
  instance_type = var.instance_type
  ami_id        = var.ami_id
  asg_min       = var.asg_min
  asg_max       = var.asg_max
  asg_desired   = var.asg_desired
}

output "alb_dns_name" {
  description = "Acesse a aplica\u00e7\u00e3o via este endere\u00e7o"
  value       = module.compute.alb_dns_name
}