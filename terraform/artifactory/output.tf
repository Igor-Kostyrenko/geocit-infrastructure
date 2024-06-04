output "artifactory_url" {
  value = "http://${google_compute_address.artifactory_ip.address}:8081"
}