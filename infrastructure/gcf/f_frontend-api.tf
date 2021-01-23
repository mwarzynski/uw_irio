module "frontend-api-eu" {
  source = "../modules/trigger_http"

  function_name = "frontend-api-eu"
  source_dir = "frontend-api"
  project = var.project
  region = "europe-west1"
  bucket = google_storage_bucket.gcf.name
}

module "frontend-api-us" {
  source = "../modules/trigger_http"

  function_name = "frontend-api-us"
  source_dir = "frontend-api"
  project = var.project
  region = "us-central1"
  bucket = google_storage_bucket.gcf.name
}

resource "google_cloudfunctions_function_iam_member" "invoker-eu" {
  project        = var.project
  region         = "europe-west1"
  cloud_function = module.frontend-api-eu.gcf.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_cloudfunctions_function_iam_member" "invoker-us" {
  project        = var.project
  region         = "us-central1"
  cloud_function = module.frontend-api-us.gcf.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
