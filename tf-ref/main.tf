terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.27"
        }
    }
}
provider "aws" {
    region = "us-east-1"
}

locals {
  production_availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
}
module "vpc" {
    source               = "./modules/vpc"
    environment          = var.environment
    vpc_cidr             = var.vpc_cidr
    public_subnets_cidr  = var.public_subnets_cidr
    private_subnets_cidr = var.private_subnets_cidr
    availability_zones   = local.production_availability_zones
}

module "EC2" {
    source               = "./modules/ec2"
    vpc_id               = module.vpc.vpc_id
    subnet_id            = module.vpc.public_subnets_id_a
}

# module "prereqs" {
#   source        = "./modules/prereqs"
#   aws_region    = var.aws_region
#   environment   = var.environment
# }
# module "dynamodb" {
#   source        = "./modules/dynamodb"
#   environment   = var.environment
# }

# module "iam" {
#   source        = "./modules/iam"
#   aws_region    = var.aws_region
#   environment   = var.environment
#   dynamodb_arn  = module.dynamodb.dynamodb_arn
#   s3_bucket_arn = module.prereqs.s3_bucket_arn
# }

# module "cluster" {
#   source        = "./modules/cluster"
#   environment   = var.environment
# }

# module "task-assign-app-php-fpm" {
#     source                             = "./modules/services/task-assign-app-php-fpm"
#     environment                        = var.environment
#     vpc_cidr                           = var.vpc_cidr
#     task_execution_role                = module.iam.task_execution_role
#     role_arn                           = module.iam.role_arn
#     fargate_cluster                    = module.cluster.fargate_cluster
#     codestarconnections_connection     = module.vpc.codestarconnections_connection
#     tflambda_bucket                    = module.prereqs.tflambda_bucket
#     vpc_id                             = module.vpc.vpc_id
#     namespace                          = module.vpc.namespace
#     private-subnet-a                   = module.vpc.private_subnets_id_a
#     private-subnet-b                   = module.vpc.private_subnets_id_b
# }

# module "task-assign-app-built-nginx-02" {
#   source                             = "./modules/services/task-assign-app-built-nginx-02"
#   environment                        = var.environment
#   vpc_cidr                           = var.vpc_cidr
#   task_execution_role                = module.iam.task_execution_role
#   role_arn                           = module.iam.role_arn
#   fargate_cluster                    = module.cluster.fargate_cluster 
#   codestarconnections_connection     = module.vpc.codestarconnections_connection
#   tflambda_bucket                    = module.prereqs.tflambda_bucket
#   vpc_id                             = module.vpc.vpc_id
#   namespace                          = module.vpc.namespace
#   private-subnet-a                   = module.vpc.private_subnets_id_a
#   private-subnet-b                   = module.vpc.private_subnets_id_b
#   listen                             = module.vpc.listen
# }
