resource "google_compute_global_forwarding_rule" "default" {
  name       = "global-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
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
    group = google_compute_region_network_endpoint_group.news_api.id
  }
}

resource "google_compute_region_network_endpoint_group" "news_api" {
  provider = google-beta

  project               = var.project
  name                  = "news-api"
  network_endpoint_type = "SERVERLESS"
  region                = local.region
  cloud_function {
    function = module.gcf.frontend-api.name
  }
}
