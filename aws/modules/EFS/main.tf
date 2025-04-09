resource "aws_cloudformation_stack" "efs" {
  name          = var.stack_name
  template_body = file(var.template_path)
}
