resource "google_compute_address" "artifactory_ip" {
  name   = "artifactory-ip"
  region = var.region

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_instance" "artifactory" {
  name         = "artifactory-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.artifactory_ip.address
    }
  }

  metadata_start_jfrog = file("${path.module}/start_jfrog.sh")

  tags = ["artifactory"]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_firewall" "artifactory_firewall" {
  name          = "artifactory-firewall"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["artifactory"]
  allow {
    protocol = "tcp"
    ports    = ["8081", "8082"]
  }
}

resource "google_storage_bucket" "artifactory_bucket" {
  name     = var.bucket_name
  location = var.region

  lifecycle {
    prevent_destroy = true
  }
}

output "artifactory_ip" {
  value = google_compute_address.artifactory_ip.address
}