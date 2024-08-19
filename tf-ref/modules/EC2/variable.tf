variable "project_name" {
  default     = "codestar-lab3"
  type        = string
  description = "project name injected into task"
}

variable "ami" {
  default     = "ami-05fa00d4c63e32376"
  type        = string
  description = "ami id for creating Ec2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t2.large"
  description = "instance type for creating EC2 instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC id for security group"
}

variable "subnet_id" {
  type        = string
  description = "subnet id for EC2 instance to be included"
}