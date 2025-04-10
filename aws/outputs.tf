output "appautoscaling_lb_dns" {
  description = "DNS name of the load balancer from appautoscaling module"
  value       = module.appautoscaling.load_balancer_dns
}

output "reverse_proxy_ipv4" {
  description = "ip of the single address to access both clouds"
  value = module.reverseproxy.reverseproxy_instance_public_ip 
}