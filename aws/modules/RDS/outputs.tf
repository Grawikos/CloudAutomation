output "rds_endpoint" {
  description = "RDS instance endpoint for SQL Server"
  value       = aws_cloudformation_stack.rds.outputs["RDSEndpoint"]
}
