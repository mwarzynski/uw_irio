variable "project" {
  type        = string
  description = "Name of your project (e.g. PROJECT_ID from `gcloud projects list`)."
}

variable "region_id" {
  type    = string
  default = "1"
}

variable "location" {
  type    = string
  default = "us-central"
}
