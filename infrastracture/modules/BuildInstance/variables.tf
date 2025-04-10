variable "stack_name" {
  description = "Name of the BuildMaster CloudFormation stack"
  type        = string
}

variable "template_path" {
  description = "Path to the buildMaster CloudFormation template"
  type        = string
}

variable "gce_project" {
  description = "The GCE project name"
  type        = string
}

variable "gce_service_acc_credential_filename" {
  description = "filename for service account credentials"
  type        = string
  default     = "gcp-service-account.json"
}