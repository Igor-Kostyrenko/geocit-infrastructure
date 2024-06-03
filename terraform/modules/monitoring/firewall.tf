resource "google_compute_firewall" "fw-monitoring" {
  project       = var.project
  name          = "fw-monitoring"
  direction     = "INGRESS"
  network       = data.google_compute_network.default.id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["grafana"]
  allow {
    protocol = "tcp"
    ports    = ["9090", "9093", "9115", "3000", "22", "443"]
  }
}