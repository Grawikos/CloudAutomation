variable "stack_name" {
  description = "Name of the S3Athena CloudFormation stack"
  type        = string
}

variable "template_path" {
  description = "Path to the S3Athena CloudFormation template"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket to store exported data"
  type        = string
  default     = "athena-data-bucket"
}

variable "lab_account_id" {
  description = "ID of the Lab account"
  type        = string
}
