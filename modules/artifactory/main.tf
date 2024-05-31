resource "google_compute_address" "artifactory_ip" {
  name   = "artifactory-ip"
  region = var.region

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_instance" "artifactory" {
  name         = "artifactory-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.artifactory_ip.address
    }
  }

  metadata = <<EOT
        #!/bin/bash

        export JFROG_HOME=/opt/jfrog
        sudo mkdir -p \$JFROG_HOME
        sudo chown -R \$(whoami):\$(whoami) \$JFROG_HOME
       
        mkdir -p $JFROG_HOME/artifactory/var/etc/
        cd $JFROG_HOME/artifactory/var/etc/
        touch ./system.yaml
        chown -R 1030:1030 $JFROG_HOME/artifactory/var
        chmod -R 777 $JFROG_HOME/artifactory/var

        sudo apt-get update
        sudo apt-get install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg \
            lsb-release

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io

        sudo systemctl start docker
        sudo systemctl enable docker

        sudo docker run --name artifactory -v $JFROG_HOME/artifactory/var/:/var/opt/jfrog/artifactory -d -p 8081:8081 -p 8082:8082 releases-docker.jfrog.io/jfrog/artifactory-oss:latest
    EOT

  tags = ["artifactory"]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_firewall" "artifactory_firewall" {
  name          = "artifactory-firewall"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["artifactory"]
  allow {
    protocol = "tcp"
    ports    = ["8081", "8082"]
  }
}

output "artifactory_ip" {
  value = google_compute_address.artifactory_ip.address
}