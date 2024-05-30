variable "project" {
  description = "The project ID to create the resources in."
  type        = string
}

variable "region" {
  description = "The region to create the resources in."
  type        = string
}

variable "zone" {
  description = "The availability zone to create the sample compute instances in. Must within the region specified in 'var.region'"
  type        = string
}

variable "env" {
  description = "Environment to deploy"
  type        = string
}

variable "machine_type" {
  description = "Machine type"
  type        = string
}
