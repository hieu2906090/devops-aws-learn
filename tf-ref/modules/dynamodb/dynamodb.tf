resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "${var.environment}-s3-backend"

  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
    
  tags = {
    "Environment" = var.environment
  }
}
///////////////define output//////////////////////////
output "dynamodb_arn" {
  value = aws_dynamodb_table.dynamodb_table.arn
}

output "dynamodb_name" {
  value = aws_dynamodb_table.dynamodb_table.name
}

