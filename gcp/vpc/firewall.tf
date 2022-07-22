resource "google_compute_firewall" "vpc" {
  description = "Allow to access to servers via IAP"
  direction   = "INGRESS"
  name        = "allow-ingress-from-iap"
  network     = google_compute_network.vpc.self_link
  source_ranges = [
    "35.235.240.0/20" # Read this for more information https://cloud.google.com/iap/docs/using-tcp-forwarding
  ]

  allow {
    ports = [
      "3389",
      "22"
    ]
    protocol = "tcp"
  }
}
