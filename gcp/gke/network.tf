data "google_compute_network" "vpc" {
  name = "vpc-${terraform.workspace}"
}

resource "google_compute_subnetwork" "gke" {
  name                     = local.cluster_name
  region                   = "europe-west1"
  ip_cidr_range            = var.gke_ip_cidr_range
  network                  = data.google_compute_network.vpc.self_link
  private_ip_google_access = "true"

  secondary_ip_range {
    range_name    = "${local.cluster_name}-pods"
    ip_cidr_range = var.gke_pods_ip_cidr_range
  }

  secondary_ip_range {
    range_name    = "${local.cluster_name}-services"
    ip_cidr_range = var.gke_services_ip_cidr_range
  }
}
