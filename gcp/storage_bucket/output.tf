output "bucket_name" {
    value = google_storage_bucket.default.name
}

output "bucket_location" {
    value = google_storage_bucket.default.location
}