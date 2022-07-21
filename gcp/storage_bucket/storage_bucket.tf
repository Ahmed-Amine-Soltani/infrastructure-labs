resource "google_storage_bucket" "default" {
  name          = var.google_storage_bucket_name
  force_destroy = false
  location      = var.google_storage_bucket_location
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}