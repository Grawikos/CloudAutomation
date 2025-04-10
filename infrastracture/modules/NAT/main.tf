resource "aws_cloudformation_stack" "nat" {
  name          = var.stack_name
  template_body = file(var.template_path)
}
