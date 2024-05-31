data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_global_address" "private_ip_address" {
  provider      = google
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.default.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google
  network                 = data.google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "google_secret_manager_secret" "database_credentials" {
  secret_id = "database-credentials"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
      replicas {
        location = "europe-west1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.database_credentials.id
  secret_data = random_password.db_password.result
}

resource "google_sql_database_instance" "main" {
  name             = var.instance_name
  database_version = "POSTGRES_12"
  region           = var.region
  deletion_protection = false
  depends_on = [google_service_networking_connection.private_vpc_connection] 

  settings {
    availability_type = "REGIONAL"
    tier              = var.db_machine_type
    disk_size         = "10"
    disk_type         = "PD_SSD"
    disk_autoresize   = "true"
    ip_configuration {
      ipv4_enabled    = "false"
      private_network = data.google_compute_network.default.id
    }
  }
}

resource "google_sql_database" "ss_demo_1" {
  name     = var.db_name
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "postgres" {
  name     = "postgres"
  instance = google_sql_database_instance.main.name
  password = google_secret_manager_secret_version.db_password_version.secret_data
  depends_on = [google_secret_manager_secret_version.db_password_version]
}