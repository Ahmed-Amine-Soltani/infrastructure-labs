resource "google_dns_managed_zone" "saa-zone" {
  name        = var.google_dns_managed_zone_name
  dns_name    = var.google_dns_managed_zone_dns_name
  description = "saa lab DNS zone"
}