data "google_compute_network" "default" {
  name = "default"
}


resource "google_compute_instance" "grafana" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["grafana"]

  

  boot_disk {
    initialize_params {
      image = var.image
  }
      }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}


resource "google_compute_firewall" "fw-monitoring" {
  project = var.project
  name          = "fw-monitoring"
  direction     = "INGRESS"
  network       = data.google_compute_network.default.id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["grafana"]
  allow {
    protocol = "tcp"
    ports    = ["9090", "9093","9115","3000", "22", "443"]
  }
}