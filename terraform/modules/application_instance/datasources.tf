data "google_compute_network" "default" {
  name = "default"
}
data "google_netblock_ip_ranges" "netblock" {}