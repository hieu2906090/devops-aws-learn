variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "dynamodb_arn" {
  type = string
}

variable "s3_bucket_arn" {
  type = string
}
variable "principal_arns" {
  description = "A list of principal arns allowed to assume the IAM role"
  default     = null
  type        = list(string)
}