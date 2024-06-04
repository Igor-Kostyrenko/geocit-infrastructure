variable "db_name" {
  type        = string
  description = "name of the postgressql"
  default     = "ss_demo_1"
}

variable "db_machine_type" {
  type        = string
  description = "machine type for db instance"
  default     = "db-custom-2-8192"
}

variable "region" {
  type        = string
  description = "region for DB"
}

variable "instance_name" {
  type        = string
  description = "name of PostgreSQL instance"
  default     = "postgres-db"
}

variable "env" {
  type        = string
  description = "Current environment to deploy"
}