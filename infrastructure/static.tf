locals {
  project_root = abspath(join("/", [path.root, ".."]))
  build_dir    = join("/", [local.project_root, "components/frontend/build"])
  static_files = tolist(fileset(local.build_dir, "**"))
}

# Bucket to store static objects
resource "google_storage_bucket" "static-files" {
  name = "${var.project}-static-files"
  # FIXME
  location = "US"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

# Everyone can read
# One may ask: why default rule and explicit dependency?
# When applying explicit acl for each object, GCP decides that objects
# that contain slash "/" in their name are missing :wtf:
resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.static-files.name
  role   = "READER"
  entity = "allUsers"
}

# Iterate over all files in static file list and put them into bucket
resource "google_storage_bucket_object" "frontend-static" {
  count  = length(local.static_files)
  name   = local.static_files[count.index]
  source = join("/", [local.build_dir, local.static_files[count.index]])
  bucket = google_storage_bucket.static-files.name
  depends_on = [google_storage_default_object_access_control.public_rule]
}
