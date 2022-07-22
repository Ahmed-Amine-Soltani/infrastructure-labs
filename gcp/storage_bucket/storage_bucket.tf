resource "google_storage_bucket" "default" {
  name          = format("saa-%s-%s", var.google_storage_bucket_name, terraform.workspace) 
  force_destroy = false
  location      = var.google_storage_bucket_location
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}