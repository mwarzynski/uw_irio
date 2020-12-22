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


// Cloud Firestore should be provisioned using... App Engine.
// https://firebase.google.com/docs/firestore/solutions/automate-database-create#create_a_database_with_terraform
//resource "google_app_engine_application" "app" {
//  project     = var.project
//  location_id = var.location
//  database_type = "CLOUD_FIRESTORE"
//}

resource "google_storage_bucket" "bucket" {
  name = "${var.project}-tf-gcf"
}

// GCF: frontend-api.
module "gcf_upload_frontend-api" {
  source = "./gcf_upload"

  function_name = "frontend-api"
  source_dir = "frontend-api"
  project = var.project
  region = local.region
  bucket = google_storage_bucket.bucket.name
}

resource "google_cloudfunctions_function" "frontend-api" {
  name        = "frontend-api"
  runtime     = "python38"
  region      = local.region

  available_memory_mb   = 128
  source_archive_bucket = module.gcf_upload_frontend-api.bucket
  source_archive_object = module.gcf_upload_frontend-api.archive_name
  trigger_http          = true
  entry_point           = "main"

  depends_on = [module.gcf_upload_frontend-api]
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.project
  region         = local.region
  cloud_function = google_cloudfunctions_function.frontend-api.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}


// GCF: backend-api.
module "gcf_upload_backend-api" {
  source = "./gcf_upload"

  function_name = "backend-api"
  source_dir = "backend-api"
  project = var.project
  region = local.region
  bucket = google_storage_bucket.bucket.name
}

resource "google_cloudfunctions_function" "backend-api" {
  name        = "backend-api"
  runtime     = "python38"
  region      = local.region

  available_memory_mb   = 128
  source_archive_bucket = module.gcf_upload_backend-api.bucket
  source_archive_object = module.gcf_upload_backend-api.archive_name

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.news.name
  }
  entry_point           = "main"

  environment_variables = {
    "GCLOUD_PROJECT" = var.project
  }

  depends_on = [module.gcf_upload_backend-api]
}

resource "google_pubsub_topic" "news" {
  name = "news"
}

resource "google_pubsub_topic" "crawler_scheduler" {
  name = "crawler_scheduler"
}

// GCF: crawler::rss.
module "gcf_upload_crawler-rss" {
  source = "./gcf_upload"

  function_name = "crawlers-rss"
  source_dir = "crawlers/rss"
  project = var.project
  region = local.region
  bucket = google_storage_bucket.bucket.name
}

resource "google_cloudfunctions_function" "crawler-rss" {
  name        = "crawler-rss"
  runtime     = "python38"
  region      = local.region

  available_memory_mb   = 128
  source_archive_bucket = module.gcf_upload_crawler-rss.bucket
  source_archive_object = module.gcf_upload_crawler-rss.archive_name
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.crawler_scheduler.name
  }
  entry_point           = "main"

  environment_variables = {
    "PROJECT_ID" = var.project
  }

  depends_on = [module.gcf_upload_crawler-rss]
}


// GCF: crawler::fake.
module "gcf_upload_crawler-fake" {
  source = "./gcf_upload"

  function_name = "crawlers-fake"
  source_dir = "crawlers/fake"
  project = var.project
  region = local.region
  bucket = google_storage_bucket.bucket.name
}

resource "google_cloudfunctions_function" "crawler-fake" {
  name        = "crawler-fake"
  runtime     = "python38"
  region      = local.region

  available_memory_mb   = 128
  source_archive_bucket = module.gcf_upload_crawler-fake.bucket
  source_archive_object = module.gcf_upload_crawler-fake.archive_name
  trigger_http          = true
  entry_point           = "main"

  environment_variables = {
    "PROJECT_ID" = var.project
  }

  depends_on = [module.gcf_upload_crawler-fake]
}


resource "google_cloud_scheduler_job" "crawler" {
  name        = "crawler"
  schedule    = "* 0 * * *" // every day at 00:00
  region      = local.region

  pubsub_target {
    topic_name = "projects/${var.project}/topics/${google_pubsub_topic.crawler_scheduler.id}"
    data       = base64encode("go")
  }
}

// It's expensive. Use only when you need to.
//resource "google_redis_instance" "frontend_cache" {
//  name           = "frontend-cache"
//  region         = local.region
//
//  memory_size_gb = 1
//}