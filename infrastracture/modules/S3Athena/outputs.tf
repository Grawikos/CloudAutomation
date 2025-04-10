output "s3_bucket" {
  description = "S3 bucket for partner data"
  value       = aws_cloudformation_stack.s3athena.outputs["Bucket"]
}
