resource "aws_cloudformation_stack" "appautoscaling" {
  name          = var.stack_name
  template_body = file(var.template_path)
}
