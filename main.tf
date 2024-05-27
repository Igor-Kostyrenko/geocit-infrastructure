
provider "google" {
  project = var.project
  region = var.region
  zone = var.zone 
}




data "google_compute_network" "default" {
  name = "default"
}

module bucket {
  source = "./modules/bucket"
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