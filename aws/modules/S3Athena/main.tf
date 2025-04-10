resource "aws_cloudformation_stack" "s3athena" {
  name          = var.stack_name
  template_body = file(var.template_path)
  
  parameters = {
    BucketName   = var.bucket_name
    LabAccountID = var.lab_account_id
  }
}

resource "null_resource" "pre_destroy_cleanup" {
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      aws s3 rm s3://${var.bucket_name}-${var.lab_account_id} --recursive || true
    EOT
  }
  depends_on = [ aws_cloudformation_stack.s3athena ]
}