
provider "google" {
  project = "kuberproject-425010"
  region = "europe-west3"
}

resource "google_compute_network" "default" {
  name = "my-network"
  auto_create_subnetworks  = false
}

resource "google_compute_subnetwork" "default" {
  name = "my-subnetwork"
  ip_cidr_range = "10.156.0.0/20"
  region        = "europe-west3"
  private_ip_google_access = true
  network = google_compute_network.default.id
}

resource "google_container_cluster" "my_cluster" {
  name = "nginx-cluster"

  location                 = "europe-west3"
  enable_autopilot         = true
  enable_l4_ilb_subsetting = true

  network    = google_compute_network.default.id
  subnetwork = google_compute_subnetwork.default.id



  # Set `deletion_protection` to `true` will ensure that one cannot
  # accidentally delete this instance by use of Terraform.
  deletion_protection = false
}
