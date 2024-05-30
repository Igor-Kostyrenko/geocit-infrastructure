resource "google_compute_firewall" "fw_ilb_to_backends" {
  name          = "${var.env}-${var.region}-fw-allow-ilb-to-backends"
  direction     = "INGRESS"
  network       = data.google_compute_network.default.id
  source_ranges = data.google_netblock_ip_ranges.netblock.cidr_blocks_ipv4
  target_tags   = ["http-server"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "9100", "9200", "22"]
  }
}

resource "google_compute_url_map" "urlmap" {
  name            = "${var.env}-${var.region}-url-map"
  description     = "URL map for ${var.env}-${var.region} load balancer"
  default_service = google_compute_backend_service.api.self_link
}

resource "google_compute_router" "default" {
  name    = "${var.env}-${var.region}-lb-http-router"
  network = data.google_compute_network.default.id
}

resource "google_compute_global_address" "global_address" {
  name         = "${var.env}-${var.region}-geo-global-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_target_http_proxy" "http" {
  name    = "${var.env}-${var.region}-geo-http-proxy"
  url_map = google_compute_url_map.urlmap.id
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "${var.env}-${var.region}-geo-http-rule"
  target     = google_compute_target_http_proxy.http[0].self_link
  ip_address = google_compute_global_address.default.address
  port_range = "80"

  depends_on = [google_compute_global_address.default]

  labels = var.custom_labels
}