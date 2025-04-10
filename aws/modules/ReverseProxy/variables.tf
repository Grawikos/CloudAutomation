variable "stack_name" {
  description = "Name of the Monitoring CloudFormation stack"
  type        = string
}

variable "template_path" {
  description = "Path to the Monitoring CloudFormation template"
  type        = string
}

variable "GCEALB" {
  description = "IPv4 address of LoadBalancer GKE"
  type = string
}