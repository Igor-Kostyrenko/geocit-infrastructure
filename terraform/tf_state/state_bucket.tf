data "google_compute_network" "default" {
  name = "default"
}


resource "google_storage_bucket" "terraform_state_bucket" {
  name          = "${var.env}-${var.region}-state-bucket"
  force_destroy = false
  location      = var.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  uniform_bucket_level_access = true

}
