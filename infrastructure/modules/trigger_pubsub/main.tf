module "upload" {
  source = "../upload"

  function_name = var.function_name
  project = var.project
  region = var.region
  bucket = var.bucket
  source_dir = var.source_dir
}

resource "google_cloudfunctions_function" "function" {
  name        = var.function_name
  runtime     = "python38"
  region      = var.region

  available_memory_mb   = var.memory
  source_archive_bucket = module.upload.bucket
  source_archive_object = module.upload.archive_name
  entry_point           = "main"

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = var.trigger_pubsub_topic
    failure_policy {
      retry = true
    }
  }

  environment_variables = {
    "PROJECT_ID"     = var.project
    "GCLOUD_PROJECT" = var.project
  }
}
