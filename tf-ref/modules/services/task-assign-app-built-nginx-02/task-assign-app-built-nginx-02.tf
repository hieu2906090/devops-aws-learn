/////////////////////////edit paremater here////////////////////////////////////
variable "task_defination" {
  default = "task-assign-app-built-nginx-02"
}
variable "task-defination-service" {
  default = "task-assign-app-built-nginx-02"
}
variable "target-group" {
  default = "task-assign-app-built-nginx-02"
}
variable "port" {
  default = 80
}
variable "http_port" {
  default = 80
}
variable "healthz" {
  default = "/"
}
variable "path" {
  default = "/*"
}
variable "priority" {
  default = 10
}
variable "repository" {
  default = "lvchi/task-assign-app"
}
variable "branch" {
  default = "deploy"
}
variable "cpu" {
  default = "256"
}
variable "memory" {
  default = "512"
}
variable "desired_count" {
  default = 1
}
variable "registry" {
  default = "446567516155.dkr.ecr.us-east-1.amazonaws.com"
}
variable "my_env_variables"{
  default = [
        {
          "name": "NGINX_HOST",
          "value": "task-assign-app-php-fpm.local"
        },
        {
          "name": "NGINX_PORT",
          "value": "80"
        }
      ]
}
//////////////////////////add task definiton///////////////////////////////////////
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/${var.task_defination}"
}
resource "aws_ecs_task_definition" "task-defination" {
  family               = "${var.task_defination}"
  execution_role_arn   = var.task_execution_role
  task_role_arn        = var.task_execution_role

  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = "${var.task-defination-service}"
      image     = "${var.registry}/${var.task-defination-service}:latest"
      essential = true
      portMappings = [
        {
          containerPort = "${var.port}"
          hostPort      = "${var.port}"
        }
      ],
      "environment": "${var.my_env_variables}",
      "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${var.task_defination}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])
}
///////////////////////////// target group /////////////////////////////////////////
resource "aws_lb_target_group" "target-group" {
  name        = "${var.target-group}"
  port        = "${var.port}"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${var.vpc_id}"
  health_check {
    path                = "${var.healthz}"
    protocol            = "HTTP"
    interval            = 30
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = "${var.listen}"
  priority     = "${var.priority}"
																 
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target-group.arn}"
  }


condition {
    host_header {
      values = ["domaintest.com"]
    }
  }

  # condition {
  #   path_pattern {
  #     values = ["${var.path}"]
  #   }
  # }
  
}

											
								  
									

			
								  
																  
	 
 

			   
					
								
	   
	 
	  
			   
				   
								
	   
	 
	  
   

/////////////////////// add service ECS ////////////////////////
resource "aws_ecs_service" "task-defination-service" {
  name            = "${var.task-defination-service}"
  cluster         = "${var.fargate_cluster}"
  task_definition = "${aws_ecs_task_definition.task-defination.arn}"
  launch_type     = "FARGATE"
  desired_count   = "${var.desired_count}"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.target-group.arn}"
    container_name   = "${var.task-defination-service}"
    container_port   = "${var.port}"
  }

  network_configuration {
    security_groups  = ["${aws_security_group.sg-service.id}"]
    subnets          = ["${var.private-subnet-a}","${var.private-subnet-b}"]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = "${aws_service_discovery_service.service_discovery.arn}"
  }

}
///////////////////////service security group///////////////////
resource "aws_security_group" "sg-service" {
  name        = "${var.environment}-${var.task-defination-service}-sg"

  ingress {
    from_port   = "${var.port}"
    to_port     = "${var.port}"
    protocol    = "TCP"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  vpc_id = "${var.vpc_id}"
  tags = {
    Environment       = "${var.environment}"
    Terraformed       = "true"
  }
}
/////////////////---ECR----////////////////////////////////////////////////
resource "aws_ecr_repository" "ecr" {
  name                 = "${var.task-defination-service}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
//////////////////add service dicovery///////////////////
resource "aws_service_discovery_service" "service_discovery" {
  name  = "${var.task-defination-service}"

  dns_config {
    namespace_id = "${var.namespace}"

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

////////////////Codepipeline//////////////////////////////
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.task-defination-service}"
  role_arn = var.role_arn

tags     = {
    "Name" = "${var.task-defination-service}"
      }
      
  artifact_store {
    location = "${var.tflambda_bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = 1
      run_order        = 1
      output_artifacts = ["source"]

      configuration = {
        ConnectionArn    = "${var.codestarconnections_connection}"
        FullRepositoryId = "${var.repository}"
        BranchName       = "${var.branch}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "${var.task-defination-service}-${var.environment}-Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      run_order       = 1
      input_artifacts = ["build"]

      configuration = {
        ClusterName = "${var.fargate_cluster}"
        ServiceName = "${var.task-defination-service}"
      }
    }
  }
}

resource "aws_codebuild_project" "codebuild_project" {
  name          = "${var.task-defination-service}"
  description   = "${var.environment}_codebuild_project"

  build_timeout = "5"
  service_role  = var.role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
  }
 
  source {
    type            = "GITHUB"
    buildspec       = file("modules/services/${var.task-defination-service}/buildspec.yml")
    location        = "https://github.com/${var.repository}"

    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = false
    }
  }

  source_version = "${var.branch}"
  
  tags = {
    "Environment" = var.environment
    "Project"     = "${var.environment}"
  }
}


