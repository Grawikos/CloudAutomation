variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "credential_filename" {
  description = "filename for service account credentials"
  type        = string
}

variable "region" {
  description = "region for gce"
  type        = string
  default     = "europe-west1"
}