output "reverseproxy_instance_public_ip" {
  description = "Public IP of the ReverseProxy Instance"
  value       = aws_cloudformation_stack.reverseproxy.outputs["ProxyInstancePublicIP"]
}
