resource "google_sql_database_instance" "main" {
  name                = "${var.env}-${var.region}-${var.instance_name}"
  database_version    = "POSTGRES_12"
  deletion_protection = false
  depends_on          = [google_service_networking_connection.private_vpc_connection]

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

resource "google_sql_user" "root" {
  name       = "root"
  instance   = google_sql_database_instance.main.name
  password   = google_secret_manager_secret_version.db_password_version.secret_data
  depends_on = [google_secret_manager_secret_version.db_password_version]
}