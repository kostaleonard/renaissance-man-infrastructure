module "gke" {
  source            = "terraform-google-modules/kubernetes-engine/google"
  name              = "renaissance-man-cluster"
  project_id        = var.project_id
  region            = google_compute_subnetwork.gke_subnetwork.region
  network           = google_compute_network.vpc_network.name
  subnetwork        = google_compute_subnetwork.gke_subnetwork.name
  ip_range_pods     = local.cluster_pod_ip_range_name
  ip_range_services = local.cluster_service_ip_range_name
}

resource "kubernetes_pod" "nginx-example" {
  metadata {
    name = "nginx-example"
    labels = {
      app = "nginx-example"
    }
  }
  spec {
    container {
      image = "nginx:1.24.0"
      name  = "nginx-example"
    }
  }
  depends_on = [module.gke]
}

resource "kubernetes_service" "nginx-example" {
  metadata {
    name = "terraform-example"
  }
  spec {
    selector = {
      app = kubernetes_pod.nginx-example.metadata[0].labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
    }
    type = "LoadBalancer"
  }
  depends_on = [module.gke]
}
