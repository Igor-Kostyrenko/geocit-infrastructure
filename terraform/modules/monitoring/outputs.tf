output "instance_public_ip" {
  value = google_compute_instance.grafana.network_interface[0].access_config[0]
}