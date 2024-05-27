terraform {
  cloud {
    organization = "capybarateam"

    workspaces {
      name = "test"
    }
  }
}
provider "google" {
  credentials = var.google_credentials
  project = var.project
  region = var.region
  zone = var.zone 
}

data "google_compute_network" "default" {
  name = "default"
}

module "pq" {

    source = "./modules/postgresql"
  
}

module "servers" {
    source = "./modules/servers"   
    region = var.region
}




module "monitoring" {
  source = "./modules/monitoring"
}