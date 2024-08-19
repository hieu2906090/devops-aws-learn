/* Create Bucket for Terraform Lambda Modules */
resource "aws_s3_bucket" "s3_bucket" {
  bucket        = "test-hfakfalk-tf-bk"
  force_destroy = false
  tags = {
    "Environment" = var.environment
  }
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "kms_key" {
  tags = {
    "Environment" = var.environment
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.kms_key.arn
    }
  }
}
/////////////////////////////////////////
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "test-fliajfla-001"
  force_destroy = true
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}


