output "nat_gateway_id" {
  description = "Exported NAT Gateway ID"
  value       = aws_cloudformation_stack.nat.outputs["NATGatewayID"]
}

output "private_route_table_id" {
  description = "Exported Private Route Table ID"
  value       = aws_cloudformation_stack.nat.outputs["PrivateRouteTableID"]
}
