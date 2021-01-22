resource "google_pubsub_topic" "news" {
  name = "news"
}

resource "google_pubsub_topic" "crawler_scheduler" {
  name = "crawler_scheduler"
}

resource "google_cloud_scheduler_job" "crawler" {
  name        = "crawler"
  schedule    = "0 * * * *" // every hour
  region      = local.region
  time_zone   = "Europe/London"

  pubsub_target {
    topic_name = "projects/${var.project}/topics/${google_pubsub_topic.crawler_scheduler.name}"
    data       = base64encode("{}")
  }
}
