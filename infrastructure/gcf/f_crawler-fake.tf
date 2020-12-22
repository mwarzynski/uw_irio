module "crawler-fake" {
  source = "./trigger_http"

  function_name = "crawler-fake"
  source_dir = "crawlers/fake"
  project = var.project
  region = local.region
  bucket = google_storage_bucket.gcf.name
}
