variable "project" {
  type = string
  description = "Name of your project (e.g. PROJECT_ID from `gcloud projects list`)."
}

variable "location" {
  type = string
  default = "us-central"
}

variable "region_id" {
  type = string
  default = "1"
}

variable "backend-api_trigger_topic" {
  type = string
}

variable "crawler-rss_trigger_topic" {
  type = string
}