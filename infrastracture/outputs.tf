output "appautoscaling_lb_dns" {
  description = "DNS name of the load balancer from appautoscaling module"
  value       = module.appautoscaling.load_balancer_dns
}