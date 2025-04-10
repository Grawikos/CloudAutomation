output "load_balancer_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_cloudformation_stack.appautoscaling.outputs["LoadBalancerDNS"]
}
