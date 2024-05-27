data "google_compute_network" "default" {
  name = "default"
}


resource "google_storage_bucket" "terraform_state_bucket" {
  name          = "capybaratfstat"
  force_destroy = true
  location      = "europe-west3"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  uniform_bucket_level_access = true

}