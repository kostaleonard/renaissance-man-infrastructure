resource "google_compute_network" "vpc_network" {
  name = "renaissance-man-vpc"
}

resource "google_compute_subnetwork" "gke_subnetwork" {
  name          = "gke-subnetwork"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  secondary_ip_range {
    ip_cidr_range = "192.168.0.0/18"
    range_name    = local.cluster_pod_ip_range_name
  }
  secondary_ip_range {
    ip_cidr_range = "192.168.64.0/18"
    range_name    = local.cluster_service_ip_range_name
  }
}
