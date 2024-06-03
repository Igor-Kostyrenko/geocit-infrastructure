output "ipostgresql_public_ip" {
  value = google_compute_global_address.private_ip_address.address
}