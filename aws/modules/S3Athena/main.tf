resource "aws_cloudformation_stack" "s3athena" {
  name          = var.stack_name
  template_body = file(var.template_path)
  
  parameters = {
    BucketName   = var.bucket_name
    LabAccountID = var.lab_account_id
  }
}