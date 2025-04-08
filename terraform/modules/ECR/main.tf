resource "aws_cloudformation_stack" "ecr" {
  name          = var.stack_name
  template_body = file(var.template_path)
}

