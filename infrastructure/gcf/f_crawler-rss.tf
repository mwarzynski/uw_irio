module "crawler-rss" {
  source = "./trigger_pubsub"

  function_name = "crawler-rss"
  source_dir = "crawlers/rss"
  project = var.project
  region = local.region
  bucket = google_storage_bucket.gcf.name

  trigger_pubsub_topic = var.crawler-rss_trigger_topic
}
