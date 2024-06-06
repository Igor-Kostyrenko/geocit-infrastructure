data "google_client_config" "default" {}
resource "google_compute_address" "default" {
  name   = "my-network"
  region = "europe-west3"
}
provider "kubernetes" {
  host                   = "https://${google_container_cluster.my_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}
resource "kubernetes_namespace" "nginx-server" {
  metadata {
    name = "nginx"
  }
}

resource "kubernetes_deployment" "nginx-server" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.nginx-server.metadata.0.name

    labels = {
      run = "nginx"
    }
  }

  spec {
    replicas = 2
    selector{
    match_labels = {
        run = "nginx"
     }
    }
    template {
      metadata {
        labels = {
          run = "nginx"
        }
      }
      spec{
        container {
          image = "nginx:latest"
          name = "nginx"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
      }
      }

    }
  }
}


resource "kubernetes_service" "nginx-server" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.nginx-server.metadata.0.name
  }
  spec {
    selector = {
      run = "nginx"
    }
    session_affinity = "ClientIP"

    port {
      protocol   = "TCP"
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
    load_balancer_ip = google_compute_address.default.address
  }
}

# Provide time for Service cleanup
resource "time_sleep" "wait_service_cleanup" {
  depends_on = [google_container_cluster.my_cluster]

  destroy_duration = "180s"
}
