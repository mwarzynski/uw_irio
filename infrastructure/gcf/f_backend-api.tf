module "backend-api" {
  source = "./trigger_pubsub"

  function_name = "backend-api"
  source_dir = "backend-api"
  project = var.project
  region = local.region
  bucket = google_storage_bucket.gcf.name

  trigger_pubsub_topic = var.backend-api_trigger_topic
}
