variable "shared_credentials_file" {
  description = "Path to file with credentials, e.g. /Users/USERNAME/.aws/credentials"
}
variable "region_aws" {
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

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region_gce" {
  description = "region for gce"
  type        = string
  default     = "europe-west1"
}

variable "cluster_name" {
  description = "name of the gke cluster"
  type        = string
  default     = "my-gke-cluster"
}