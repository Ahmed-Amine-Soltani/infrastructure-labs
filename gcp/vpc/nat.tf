resource "google_compute_router" "eu_west_1" {
  name    = "${terraform.workspace}-cloud-router"
  region  = google_compute_subnetwork.eu_west_1.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "eu_west_1" {
  name                                = "${terraform.workspace}-nat"
  router                              = google_compute_router.eu_west_1.name
  region                              = google_compute_router.eu_west_1.region
  nat_ip_allocate_option              = var.nat_ip_allocate_option
  nat_ips                             = var.nat_ips
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  min_ports_per_vm                    = 64
  enable_endpoint_independent_mapping = true
  log_config {
    enable = false
    filter = "ALL"
  }
}
