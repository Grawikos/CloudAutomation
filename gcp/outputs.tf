output "master_ip" {
  value = google_compute_instance.kubemaster.network_interface[0].access_config[0].nat_ip
}

output "node1_ip" {
  value = google_compute_instance.node1.network_interface[0].access_config[0].nat_ip
}
