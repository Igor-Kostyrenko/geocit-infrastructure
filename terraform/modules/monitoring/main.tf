resource "google_compute_instance" "grafana" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["grafana"]
  allow_stopping_for_update = true
  service_account {
    email  = "jenkins@capybarageocity.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    "ssh-keys" = <<EOT
      ansible: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCslfUc3Cjn8HMaIzs/362n8REXP7a+O7cEioyUEd9FaiApsKsxDui7tNPNhE9dO5Bzaa3MNjdx17rTWzlgUK7g/KboqJ8+iHU5lK6c6QEDOJd3O0gG7pQGOTkPJ2wuUsfuv39p3vz20Q5UlBWPmX92YXArcfWzc0l55ZQQkZj20ZqfgjmCrmBiyuoVhMuogBAIjQGwkWqm7HSucJBEGG6e+rFWFfM9q2uueAYIXOX85l4ZEH3XN4N1EbN52sDV648dMX/rrb6TXam9SEd6w2u60Mn3oCVdIj17n+nlY8LJdm62x0gj5NM3+h7JuIlcX322/u79n50ZXmcps4+BBXgx ansible
     EOT
  }
}
