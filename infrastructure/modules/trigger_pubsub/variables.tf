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

variable "function_name" {
  type = string
  description = "Name of the function to deploy."
}

variable "source_dir" {
  type = string
}

variable "trigger_pubsub_topic" {
  type = string
}

variable "memory" {
  type = number
  default = 128
}
