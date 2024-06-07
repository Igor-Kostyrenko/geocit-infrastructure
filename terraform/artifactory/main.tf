terraform {
  required_version = "= 1.8.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.31.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "artifactory_network" {
  name = "artifactory-network"
}

resource "google_compute_address" "artifactory_ip" {
  name   = "artifactory-ip"
  region = var.region
}

resource "google_compute_instance" "artifactory" {
  name         = "artifactory-vm"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = google_compute_network.artifactory_network.self_link
    access_config {
      nat_ip = google_compute_address.artifactory_ip.address
    }
  }

  tags = ["artifactory"]
}

resource "google_compute_firewall" "artifactory_firewall" {
  name          = "artifactory-firewall"
  network       = google_compute_network.artifactory_network.self_link
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["artifactory"]
  allow {
    protocol = "tcp"
    ports    = ["22", "8081", "8082"]
  }
}

output "artifactory_ip" {
  value = google_compute_address.artifactory_ip.address
}