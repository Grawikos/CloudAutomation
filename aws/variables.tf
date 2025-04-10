variable "shared_credentials_file" {
  description = "Path to file with credentials, e.g. /Users/USERNAME/.aws/credentials"
}
variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "default"
}

variable "gce_service_acc_credential_filename" {
  description = "filename for service account credentials"
  type        = string
  default     = "gcp-service-account.json"
}