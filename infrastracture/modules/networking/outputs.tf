output "vpc_id" {
  description = "Exported VPC ID"
  value       = aws_cloudformation_stack.networking.outputs["VPCRef"]
}

output "public_subnet1_id" {
  description = "Exported Public Subnet 1 ID"
  value       = aws_cloudformation_stack.networking.outputs["PublicSubnet1Ref"]
}

output "public_subnet2_id" {
  description = "Exported Public Subnet 2 ID"
  value       = aws_cloudformation_stack.networking.outputs["PublicSubnet2Ref"]
}

output "private_subnet1_id" {
  description = "Exported Private Subnet 1 ID"
  value       = aws_cloudformation_stack.networking.outputs["PrivateSubnet1Ref"]
}

output "private_subnet2_id" {
  description = "Exported Private Subnet 2 ID"
  value       = aws_cloudformation_stack.networking.outputs["PrivateSubnet2Ref"]
}
