module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.0"
  router     = google_compute_router.default.name
  project_id = var.project
  region     = var.region
  name       = "${var.env}-${var.region}-cloud-nat-lb-http-router"
}