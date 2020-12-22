locals {
  // region represents the full name for the region, e.g. 'us-central1'.
  // var.location is the main name of the region: "us-central"
  // var.region_id is the (string) ID of the location: "1"
  region = "${var.location}${var.region_id}"
}

resource "google_storage_bucket" "gcf" {
  name = "${var.project}-tf-gcf"
}
