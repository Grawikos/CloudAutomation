variable "stack_name" {
  description = "Name of the EFS CloudFormation stack"
  type        = string
}

variable "template_path" {
  description = "Path to the EFS CloudFormation template (efs.yml)"
  type        = string
}
