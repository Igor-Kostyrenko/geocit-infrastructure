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
  region = var.region
}
