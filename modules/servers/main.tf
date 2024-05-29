data "google_compute_network" "default" {
  name = "default"
}
data "google_netblock_ip_ranges" "netblock" {}

# ------------------------------------------------------------------------------
# CREATE NAT
# ------------------------------------------------------------------------------


resource "google_compute_router" "default" {
  name    = "lb-http-router"
  network = data.google_compute_network.default.id
  region  = var.region
}

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.0"
  router     = google_compute_router.default.name
  project_id = var.project
  region     = var.region
  name       = "cloud-nat-lb-http-router"
}
# ------------------------------------------------------------------------------
# CREATE THE LOAD BALANCER
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# CREATE A PUBLIC IP ADDRESS
# ------------------------------------------------------------------------------

resource "google_compute_global_address" "default" {
  project      = var.project
  name         = "${var.name}-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

# ------------------------------------------------------------------------------
# IF PLAIN HTTP ENABLED, CREATE FORWARDING RULE AND PROXY
# ------------------------------------------------------------------------------

resource "google_compute_target_http_proxy" "http" {
  count   = var.enable_http ? 1 : 0
  project = var.project
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.urlmap.id
}

resource "google_compute_global_forwarding_rule" "http" {
  count      = var.enable_http ? 1 : 0
  project    = var.project
  name       = "${var.name}-http-rule"
  target     = google_compute_target_http_proxy.http[0].self_link
  ip_address = google_compute_global_address.default.address
  port_range = "80"

  depends_on = [google_compute_global_address.default]

  labels = var.custom_labels
}

# ------------------------------------------------------------------------------
# CREATE THE URL MAP TO MAP PATHS TO BACKENDS
# ------------------------------------------------------------------------------

resource "google_compute_url_map" "urlmap" {
  project = var.project
  name        = "${var.name}-url-map"
  description = "URL map for ${var.name}"
  default_service = google_compute_backend_service.api.self_link
}

# ------------------------------------------------------------------------------
# CREATE THE BACKEND SERVICE CONFIGURATION FOR THE INSTANCE GROUP
# ------------------------------------------------------------------------------

resource "google_compute_backend_service" "api" {
  project = var.project
  name        = "${var.name}-api"
  description = "API Backend for ${var.name}"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = google_compute_instance_group_manager.api.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  health_checks = [google_compute_health_check.default.id]
  depends_on = [google_compute_instance_group_manager.api]
}

# ------------------------------------------------------------------------------
# CONFIGURE HEALTH CHECK FOR THE API BACKEND
# ------------------------------------------------------------------------------

resource "google_compute_health_check" "default" {
  project = var.project
  name    = "${var.name}-hc"

  http_health_check {
    port         = 80
  }

  check_interval_sec = 5
  timeout_sec        = 5
}



# ------------------------------------------------------------------------------
# CREATE THE INSTANCE GROUP AND THE BACKEND SERVICE CONFIGURATION
# ------------------------------------------------------------------------------

resource "google_compute_instance_group_manager" "api" {
  project   = var.project
  name      = "${var.name}-igm"
  base_instance_name = "app"
  zone      = var.zone
  version {
    instance_template  = google_compute_instance_template.appserver.id
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

resource "google_compute_target_pool" "appserver" {
  name    = "my-target-pool"
  project = var.project
  region  = var.region
}

resource "google_compute_instance_template" "appserver" {
  name         = "my-instance-template"
  machine_type = var.machine_type
  can_ip_forward = false
  project      = var.project
  tags         = [module.cloud-nat.router_name, "http-server", "cit", "allow-lb-service", "allow-ssh", "private-app"]

  disk {
    source_image = var.image
  }
  
  network_interface {
    network = data.google_compute_network.default.id
  }

   metadata = {
    "ssh-keys" = <<EOT
      ubuntu: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCslfUc3Cjn8HMaIzs/362n8REXP7a+O7cEioyUEd9FaiApsKsxDui7tNPNhE9dO5Bzaa3MNjdx17rTWzlgUK7g/KboqJ8+iHU5lK6c6QEDOJd3O0gG7pQGOTkPJ2wuUsfuv39p3vz20Q5UlBWPmX92YXArcfWzc0l55ZQQkZj20ZqfgjmCrmBiyuoVhMuogBAIjQGwkWqm7HSucJBEGG6e+rFWFfM9q2uueAYIXOX85l4ZEH3XN4N1EbN52sDV648dMX/rrb6TXam9SEd6w2u60Mn3oCVdIj17n+nlY8LJdm62x0gj5NM3+h7JuIlcX322/u79n50ZXmcps4+BBXgx ubuntu
     EOT
  }


}
resource "google_compute_autoscaler" "api" {
  name    = "${var.name}-autoscaler"
  project = var.project
  zone    = var.zone
  target  = google_compute_instance_group_manager.api.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
  
}


# ------------------------------------------------------------------------------
# CREATE A FIREWALL TO ALLOW ACCESS TO LB AND FROM THE LB TO THE INSTANCE
# ------------------------------------------------------------------------------

resource "google_compute_firewall" "fw_ilb_to_backends" {
  project = var.project
  name          = "fw-allow-ilb-to-backends"
  direction     = "INGRESS"
  network       = data.google_compute_network.default.id
  source_ranges = data.google_netblock_ip_ranges.netblock.cidr_blocks_ipv4
  target_tags   = ["http-server"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "9100", "9200","22"]
  }
}


