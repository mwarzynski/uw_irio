provider "google-beta" {
  project = var.project
}

module "lb-http" {
  source  = "./network_endpoint_group"
  name    = "tf-${var.name}-lb"
  project = var.project

  ssl                             = false
  managed_ssl_certificate_domains = []
  https_redirect                  = false

  backends = {
    default = {
      description = null
      groups = [
        {
          group = google_compute_region_network_endpoint_group.gcf.id
        }
      ]
      enable_cdn             = false
      security_policy        = null
      custom_request_headers = null

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
      log_config = {
        enable      = false
        sample_rate = null
      }
    }
  }
}

resource "google_compute_region_network_endpoint_group" "gcf" {
  provider              = google-beta
  name                  = "${var.gcf_name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_function {
    function = var.gcf_name
  }
}