variable "name" {
  type        = string
  description = "name of the VM instance"
  default     = "monitoring1"
}

variable "machine_type" {
  type        = string
  description = "machine type for VM instance"
  default     = "e2-medium"
}

variable "zone" {

  type        = string
  description = "region for DB"
  default     = "europe-west3-c"

}

variable "image" {
  type        = string
  description = "image type"
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"

}

variable "project" {
  type        = string
  description = "id of project"
  default     = "capybarageocity"

}