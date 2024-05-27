terraform {
 backend "gcs" {
   bucket  = "capybaratfstat"
   prefix  = "terraform/state"
   credentials = "credentials.json"
 }
}