# -------------------------------------------------------------------
# VPC única — necessária para o ALB conseguir alcançar ambas as AZs
# -------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "zenon-vpc" }
}

# Subnets públicas em AZs distintas
resource "aws_subnet" "public_aza" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_pub_aza_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = { Name = "zenon-subnet-pub-aza" }
}

resource "aws_subnet" "public_azb" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_pub_azb_cidr
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = { Name = "zenon-subnet-pub-azb" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = { Name = "zenon-igw" }
}

# Route Table pública (compartilhada pelas duas subnets)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "zenon-rt-public" }
}

resource "aws_route_table_association" "aza" {
  subnet_id      = aws_subnet.public_aza.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "azb" {
  subnet_id      = aws_subnet.public_azb.id
  route_table_id = aws_route_table.public.id
}

# -------------------------------------------------------------------
# Subnets privadas — onde as EC2 ficam sem acesso direto da internet
# -------------------------------------------------------------------
resource "aws_subnet" "private_aza" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_priv_aza_cidr
  availability_zone = "${var.region}a"

  tags = { Name = "zenon-subnet-priv-aza" }
}

resource "aws_subnet" "private_azb" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_priv_azb_cidr
  availability_zone = "${var.region}b"

  tags = { Name = "zenon-subnet-priv-azb" }
}

# -------------------------------------------------------------------
# NAT Gateway — permite que as EC2 privadas acessem a internet
# (para downloads de pacotes, atualizações, etc.)
# Usamos 1 NAT GW na AZ-A para reduzir custo.
# Para alta disponibilidade total, crie um segundo em AZ-B.
# -------------------------------------------------------------------
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "zenon-eip-nat" }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_aza.id # NAT GW fica na subnet PÚBLICA

  tags       = { Name = "zenon-nat-gw" }
  depends_on = [aws_internet_gateway.igw]
}

# Route Tables privadas apontam para o NAT Gateway
resource "aws_route_table" "private_aza" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = { Name = "zenon-rt-priv-aza" }
}

resource "aws_route_table" "private_azb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = { Name = "zenon-rt-priv-azb" }
}

resource "aws_route_table_association" "priv_aza" {
  subnet_id      = aws_subnet.private_aza.id
  route_table_id = aws_route_table.private_aza.id
}

resource "aws_route_table_association" "priv_azb" {
  subnet_id      = aws_subnet.private_azb.id
  route_table_id = aws_route_table.private_azb.id
}

# -------------------------------------------------------------------
# Security Groups
# -------------------------------------------------------------------

# ALB — aceita tráfego HTTP e HTTPS da internet
resource "aws_security_group" "alb" {
  name        = "zenon-sg-alb"
  description = "Allow HTTP and HTTPS inbound to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "zenon-sg-alb" }
}

# EC2 — aceita tráfego apenas do ALB
resource "aws_security_group" "ec2" {
  name        = "zenon-sg-ec2"
  description = "Allow HTTP only from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "zenon-sg-ec2" }
}