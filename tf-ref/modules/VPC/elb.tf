module "security_group_public" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${var.environment}-alb-internet-sg"
  description = "Security group for example usage with ALB"
  vpc_id = aws_vpc.vpc.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

/////////////-----ALB INTERNET----////////////////////////////
module "alb-internet" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"
  
  name = "${var.environment}-ALB-INTERNET"

  load_balancer_type            = "application"
  enable_deletion_protection    = true

  vpc_id = aws_vpc.vpc.id
  subnets = [element(aws_subnet.public_subnet.*.id, 0), element(aws_subnet.public_subnet.*.id, 1)]
  security_groups = [module.security_group_public.security_group_id]
  internal = false

  target_groups = [
    {
      name_prefix      = "${var.environment}"
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
    }
  ]


  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

 
  tags = {
    Name              = "${var.environment}-ALB-INTERNET"
    Terraformed       = "true"
  }
}