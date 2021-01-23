output "url-eu" {
  value = module.gcf.frontend-api-eu.https_trigger_url
}

output "url-us" {
  value = module.gcf.frontend-api-us.https_trigger_url
}
