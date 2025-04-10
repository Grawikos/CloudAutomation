resource "aws_cloudformation_stack" "ecr" {
  name          = var.stack_name
  template_body = file(var.template_path)
}

resource "null_resource" "pre_destroy_cleanup" {
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      aws ecr delete-repository --repository-name appimagerepository --force || true
    EOT
  }
  depends_on = [ aws_cloudformation_stack.ecr ]
}