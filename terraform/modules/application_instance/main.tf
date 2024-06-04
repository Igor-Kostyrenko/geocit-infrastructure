resource "google_compute_instance_template" "appserver" {
  name           = "${var.env}-${var.region}-instance-template"
  machine_type   = var.machine_type
  can_ip_forward = false
  tags           = [module.cloud-nat.router_name, "http-server", "cit", "allow-lb-service", "allow-ssh", "private-app"]

  disk {
    source_image = var.image
  }

  network_interface {
    network = data.google_compute_network.default.id
  }

  metadata = {
    "ssh-keys" = <<EOT
      ansible: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCslfUc3Cjn8HMaIzs/362n8REXP7a+O7cEioyUEd9FaiApsKsxDui7tNPNhE9dO5Bzaa3MNjdx17rTWzlgUK7g/KboqJ8+iHU5lK6c6QEDOJd3O0gG7pQGOTkPJ2wuUsfuv39p3vz20Q5UlBWPmX92YXArcfWzc0l55ZQQkZj20ZqfgjmCrmBiyuoVhMuogBAIjQGwkWqm7HSucJBEGG6e+rFWFfM9q2uueAYIXOX85l4ZEH3XN4N1EbN52sDV648dMX/rrb6TXam9SEd6w2u60Mn3oCVdIj17n+nlY8LJdm62x0gj5NM3+h7JuIlcX322/u79n50ZXmcps4+BBXgx ansible
     EOT
    startup-script = <<-EOF1
      #! /bin/bash
      set -euo pipefail

      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y nginx-light jq

      NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/hostname")
      IP=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip")
      METADATA=$(curl -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/?recursive=True" | jq 'del(.["startup-script"])')

      cat <<EOF > /var/www/html/index.html
      <pre>
      Name: $NAME
      IP: $IP
      Metadata: $METADATA
      </pre>
      EOF
    EOF1
  }
}
