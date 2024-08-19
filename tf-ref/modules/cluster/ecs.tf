resource "aws_ecs_cluster" "foo" {
  name = "${var.environment}-test"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

output "fargate_cluster" {
  value = aws_ecs_cluster.foo.name
}

