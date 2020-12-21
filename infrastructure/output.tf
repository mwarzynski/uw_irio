output "url" {
  value = google_cloudfunctions_function.frontend-api.https_trigger_url
}
