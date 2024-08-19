variable "task_execution_role" {
  type = string
}
variable "environment" {
  type = string
}
variable "role_arn" {
  type = string
}
variable "fargate_cluster" {
  type = string
}
variable "codestarconnections_connection" {
  type = string
}
variable "tflambda_bucket" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "vpc_cidr" {
   description = "CIDR for the VPC"
   type = string
}
variable "private-subnet-a" {
   type = string
}
variable "private-subnet-b" {
   type = string
}

variable "namespace" {
   type = string
}
variable "listen" {
   type = string
}



