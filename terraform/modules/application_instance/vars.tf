variable "project" {
  description = "The project ID to create the resources in."
  type        = string
}

variable "region" {
  description = "The region to create the resources in."
  type        = string
}

variable "enable_ssl" {
  description = "Set to true to enable ssl. If set to 'true', you will also have to provide 'var.custom_domain_name'."
  type        = bool
}

variable "custom_domain_name" {
  description = "Custom domain name."
  type        = string
  default     = ""
}

variable "custom_labels" {
  description = "A map of custom labels to apply to the resources. The key is the label name and the value is the label value."
  type        = map(string)
}

variable "machine_type" {

  description = "Define the type of machine for instance group"
  type        = string
}

variable "image" {

  description = "type of image for instnces"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"

}

variable "env" {
  description = "Environment to deploy"
  type        = string
}
