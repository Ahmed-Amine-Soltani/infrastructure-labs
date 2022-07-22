resource "google_compute_network" "vpc" {
  name                    = "vpc-${terraform.workspace}"
  description             = var.vpc_description
  auto_create_subnetworks = false

  # We explicitly prevent destruction using terraform. Remove this only if you really know what you're doing.
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_subnetwork" "eu_west_1" {
  name                     = "${terraform.workspace}-eu-west-1"
  region                   = "europe-west1"
  ip_cidr_range            = var.subnet_ip_cidr_range
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = "true"

  dynamic "secondary_ip_range" {
    for_each = var.subnet_secondary_ip_range

    content {
      range_name    = secondary_ip_range.value["range_name"]
      ip_cidr_range = secondary_ip_range.value["ip_cidr_range"]
    }
  }

  # We explicitly prevent destruction using terraform. Remove this only if you really know what you're doing.
  lifecycle {
    prevent_destroy = true
  }
}