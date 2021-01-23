locals {
  lb_address = google_compute_global_address.default.address
}

resource "google_compute_global_address" "default" {
  project    = var.project
  name       = "news-api-address"
}

output "lb_address" {
  value = local.lb_address
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "global-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = local.lb_address
}

resource "google_compute_target_http_proxy" "default" {
  name    = "news-api-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name = "news-api-url-map"

  # Why do i have to add this?
  default_service = google_compute_backend_service.default.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "news-service"
  }

  path_matcher {
    name            = "news-service"
    default_service = google_compute_backend_bucket.static.id

    path_rule {
      paths   = ["/api/news"]
      service = google_compute_backend_service.default.id
    }
  }
}

resource "google_compute_backend_bucket" "static" {
  name        = "static-files"
  bucket_name = google_storage_bucket.static-files.name
  enable_cdn  = true
}

resource "google_compute_backend_service" "default" {
  provider = google-beta
  project  = var.project

  name = "news-api-service"

  backend {
    group = google_compute_region_network_endpoint_group.news_api_us.id
  }
  backend {
    group = google_compute_region_network_endpoint_group.news_api_eu.id
  }
}

resource "google_compute_region_network_endpoint_group" "news_api_us" {
  provider = google-beta

  project               = var.project
  name                  = "news-api-us"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  cloud_function {
    function = module.gcf.frontend-api-us.name
  }
}

resource "google_compute_region_network_endpoint_group" "news_api_eu" {
  provider = google-beta

  project               = var.project
  name                  = "news-api-eu"
  network_endpoint_type = "SERVERLESS"
  region                = "europe-west1"
  cloud_function {
    function = module.gcf.frontend-api-eu.name
  }
}
