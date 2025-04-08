output "efs_ip1" {
  description = "IP address from the first EFS mount target"
  value       = aws_cloudformation_stack.efs.outputs["EFSIP1"]
}

output "efs_ip2" {
  description = "IP address from the second EFS mount target"
  value       = aws_cloudformation_stack.efs.outputs["EFSIP2"]
}

output "efs_dns_name" {
  description = "EFS File System DNS Name"
  value       = aws_cloudformation_stack.efs.outputs["EFSDNSName"]
}

output "efs_security_group" {
  description = "Reference to the Application Security Group"
  value       = aws_cloudformation_stack.efs.outputs["SecurityGroupRef"]
}

