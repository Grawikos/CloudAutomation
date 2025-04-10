resource "aws_cloudformation_stack" "reverseproxy" {
  name          = var.stack_name
  template_body = file(var.template_path)

  parameters = {
    GCEALB = var.GCEALB
  }
}

