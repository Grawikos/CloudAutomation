output "monitoring_instance_private_ip" {
  description = "Private IP of the Monitoring Instance"
  value       = aws_cloudformation_stack.monitoring.outputs["PMonitoringInstancePublicIP"]
}
