terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.27"
        }
    }
    required_version = ">= 0.14.9"
}

provider "aws" {
    profile = "default"
    region = "ap-southeast-1"
}

module "vpc" {
  source = "../module"
  project_name = "module_project"
}