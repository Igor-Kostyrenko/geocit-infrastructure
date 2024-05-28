terraform {
 backend "gcs" {
   bucket  = "capybaratfstat"
   prefix  = "terraform/state"
   
 }
}