resource "google_compute_instance_group_manager" "api" {
  name               = "${var.env}-${var.region}-igm"
  base_instance_name = "${var.env}-${var.region}-app"
  version {
    instance_template = google_compute_instance_template.appserver.id
  }

  lifecycle {
    create_before_destroy = true
  }

  target_pools = [google_compute_target_pool.appserver.id]

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.default.id
    initial_delay_sec = 300
  }
}

resource "google_compute_health_check" "default" {
  name = "${var.env}-${var.region}-hc"

  http_health_check {
    port = 80
  }

  check_interval_sec = 5
  timeout_sec        = 5
}