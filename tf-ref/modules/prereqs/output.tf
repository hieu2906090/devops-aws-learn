output "tflambda_bucket" {
  value = "${aws_s3_bucket.codepipeline_bucket.bucket}"
} 
