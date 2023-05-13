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
  }
}

provider "google" {
  project = "renaissance-man-385715"
  region  = "us-east4"
  zone    = "us-east4-a"
}

resource "google_compute_network" "vpc_network" {
  name = "renaissance-man-vpc"
}
