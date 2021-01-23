provider "google" {
  project = var.project
  region  = var.location
}

locals {
  // region represents the full name for the region, e.g. 'us-central1'.
  // var.location is the main name of the region: "us-central"
  // var.region_id is the (string) ID of the location: "1"
  region = "${var.location}${var.region_id}"
}

module "gcf" {
  source = "./gcf"

  project   = var.project
  location  = var.location
  region_id = var.region_id

  backend-api_trigger_topic = google_pubsub_topic.news.name
  crawler-rss_trigger_topic = google_pubsub_topic.crawler_scheduler.name
}
