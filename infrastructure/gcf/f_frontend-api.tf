module "frontend-api" {
  source = "./trigger_http"

  function_name = "frontend-api"
  source_dir = "frontend-api"
  project = var.project
  region = local.region
  bucket = google_storage_bucket.gcf.name
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.project
  region         = local.region
  cloud_function = module.frontend-api.gcf.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
