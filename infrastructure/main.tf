provider "google" {
  project = var.project
  region = var.location
}

locals {
  // region represents the full name for the region, e.g. 'us-central1'.
  // var.location is the main name of the region: "us-central"
  // var.region_id is the (string) ID of the location: "1"
  region = "${var.location}${var.region_id}"
}

resource "google_project_service" "cloudscheduler" {
  project = var.project
  service = "cloudscheduler.googleapis.com"
}

resource "google_project_service" "cloudfunctions" {
  project = var.project
  service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "cloudbuild" {
  project = var.project
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "redis" {
  project = var.project
  service = "redis.googleapis.com"
}

module "gcf" {
  source = "./gcf"

  project = var.project
  location = var.location
  region_id = var.region_id

  backend-api_trigger_topic = google_pubsub_topic.news.name
  crawler-rss_trigger_topic = google_pubsub_topic.crawler_scheduler.name

  depends_on = [
    google_project_service.cloudfunctions,
    google_project_service.cloudbuild,
  ]
}
