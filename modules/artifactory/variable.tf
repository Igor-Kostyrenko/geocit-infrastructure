variable "project" {
  description = "The project ID to create the resources in."
  type        = string
  default     = "capybarageocity"
}

variable "region" {
  description = "The region to create the resources in."
  type        = string
  default     = "europe-west3"
}

variable "zone" {
  description = "The availability zone to create the sample compute instances in. Must within the region specified in 'var.region'"
  type        = string
  default     = "europe-west3-c"
}

variable "machine_type" {
  description = "Define the type of machine for instance group"
  type        = string
  default     = "e2-micro"
}