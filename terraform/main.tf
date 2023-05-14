terraform {
  required_version = ">= 1.2.0"
  cloud {
    organization = "kosta-mlops"
    workspaces {
      name = "renaissance-man-infrastructure"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.63.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

locals {
  cluster_pod_ip_range_name     = "renaissance-man-cluster-pod-ips"
  cluster_service_ip_range_name = "renaissance-man-cluster-service-ips"
}
