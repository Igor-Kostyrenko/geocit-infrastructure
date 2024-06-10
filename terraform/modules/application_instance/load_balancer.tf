resource "google_compute_backend_service" "api" {
  name        = "${var.env}-${var.region}-api"
  description = "API Backend for ${var.env}-${var.region} load balancer"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false
  session_affinity    = "CLIENT_IP"

  backend {
    group           = google_compute_instance_group_manager.api.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  health_checks = [google_compute_health_check.default.id]
  depends_on    = [google_compute_instance_group_manager.api]
}

resource "google_compute_autoscaler" "api" {
  name   = "${var.env}-${var.region}-autoscaler"
  target = google_compute_instance_group_manager.api.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.9
    }
  }
}

resource "google_compute_target_pool" "appserver" {
  name = "${var.env}-${var.region}-target-pool"
}
