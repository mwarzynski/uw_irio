// Cloud Firestore should be provisioned using... App Engine.
// https://firebase.google.com/docs/firestore/solutions/automate-database-create#create_a_database_with_terraform
resource "google_app_engine_application" "app" {
  project       = var.project
  location_id   = var.location
  database_type = "CLOUD_FIRESTORE"
}
