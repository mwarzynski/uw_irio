variable "function_name" {
  type = string
  description = "Name of the function to deploy."
}

variable "project" {
  type = string
  description = "Name of your project (e.g. PROJECT_ID from `gcloud projects list`)."
}

variable "region" {
  type = string
}

variable "bucket" {
  type = string
}