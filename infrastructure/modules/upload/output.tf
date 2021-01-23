output "bucket" {
  value = google_storage_bucket_object.archive.bucket
}

output "archive_name" {
  value = google_storage_bucket_object.archive.name
}