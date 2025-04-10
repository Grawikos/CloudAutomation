output "ecr_registry" {
  description = "ECR registry endpoint (without repository name)"
  value       = aws_cloudformation_stack.ecr.outputs["ECRRegistry"]
}

output "ecr_repository_uri" {
  description = "Full repository URI (registry + repository)"
  value       = aws_cloudformation_stack.ecr.outputs["ECRRepositoryUri"]
}
