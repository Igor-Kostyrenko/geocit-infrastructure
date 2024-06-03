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

variable "create_dns_entry" {
  description = "If set to true, create a DNS A Record in Cloud DNS for the domain specified in 'custom_domain_name'."
  type        = bool
  default     = false
}

variable "custom_domain_name" {
  description = "Custom domain name."
  type        = string
  default     = ""
}

variable "dns_managed_zone_name" {
  description = "The name of the Cloud DNS Managed Zone in which to create the DNS A Record specified in var.custom_domain_name. Only used if var.create_dns_entry is true."
  type        = string
  default     = "replace-me"
}

variable "dns_record_ttl" {
  description = "The time-to-live for the load balancer A record (seconds)"
  type        = string
  default     = 60
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