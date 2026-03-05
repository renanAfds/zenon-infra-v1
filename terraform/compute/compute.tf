# -------------------------------------------------------------------
# Launch Template — define o perfil das instâncias dos ASGs
# -------------------------------------------------------------------
resource "aws_launch_template" "app" {
  name_prefix   = "zenon-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false # EC2 em subnet privada, sem IP público
    security_groups             = [var.sg_ec2_id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Zenon — $(hostname)</h1>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "zenon-ec2" }
  }

  lifecycle { create_before_destroy = true }
}

# -------------------------------------------------------------------
# ASG — AZ-A
# -------------------------------------------------------------------
resource "aws_autoscaling_group" "aza" {
  name                = "zenon-asg-aza"
  vpc_zone_identifier = [var.subnet_priv_aza_id] # subnet PRIVADA
  target_group_arns   = [aws_lb_target_group.app.arn]
  health_check_type   = "ELB"

  min_size         = var.asg_min
  max_size         = var.asg_max
  desired_capacity = var.asg_desired

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "zenon-asg-aza"
    propagate_at_launch = true
  }
}

# -------------------------------------------------------------------
# ASG — AZ-B
# -------------------------------------------------------------------
resource "aws_autoscaling_group" "azb" {
  name                = "zenon-asg-azb"
  vpc_zone_identifier = [var.subnet_priv_azb_id] # subnet PRIVADA
  target_group_arns   = [aws_lb_target_group.app.arn]
  health_check_type   = "ELB"

  min_size         = var.asg_min
  max_size         = var.asg_max
  desired_capacity = var.asg_desired

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "zenon-asg-azb"
    propagate_at_launch = true
  }
}

# -------------------------------------------------------------------
# ALB — distribui carga entre os dois ASGs
# -------------------------------------------------------------------
resource "aws_lb" "app" {
  name               = "zenon-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_id]
  subnets            = [var.subnet_aza_id, var.subnet_azb_id]

  tags = { Name = "zenon-alb" }
}

# Target Group — onde o ALB encaminha as requisições
resource "aws_lb_target_group" "app" {
  name     = "zenon-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = { Name = "zenon-tg" }
}

# Listener HTTP — redireciona tudo para HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Listener HTTPS — termina TLS e encaminha para o Target Group
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.app.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}