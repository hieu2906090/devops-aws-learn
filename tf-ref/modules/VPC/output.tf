output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnets_id_a" {
  value = element(aws_subnet.public_subnet.*.id, 0)
}
output "public_subnets_id_b" {
  value = element(aws_subnet.public_subnet.*.id, 1)
}

output "private_subnets_id_a" {
  value = element(aws_subnet.private_subnet.*.id, 0)
}
output "private_subnets_id_b" {
  value = element(aws_subnet.private_subnet.*.id, 1)
}

output "listen" {
  value = module.alb-internet.http_tcp_listener_arns[0]
  # value = "arn:aws:elasticloadbalancing:us-east-1:446567516155:listener/app/DEV25-ALB-INTERNET/11c050657cb9c306/e8031f67fbc14ce9"
}