resource "aws_cloudformation_stack" "buildmaster" {
  name          = var.stack_name
  template_body = file(var.template_path)

  parameters = {
    GCEProjectName = var.project_id   
    GCEServiceAccFileName = var.gce_service_acc_credential_filename
  }
}

