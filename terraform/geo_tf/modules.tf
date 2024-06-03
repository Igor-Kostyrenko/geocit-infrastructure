module "pq" {
  source = "../modules/postgresql"
  region = var.region
  env    = var.env
}

module "application_instance" {
  source        = "../modules/application_instance"
  project       = var.project
  region        = var.region
  env           = var.env
  custom_labels = {}
  machine_type  = var.machine_type
  enable_ssl    = false
}

module "monitoring" {
  source = "../modules/monitoring"
}