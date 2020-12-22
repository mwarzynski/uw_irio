module "loadbalancer" {
  source = "./loadbalancer"

  project = var.project
  region = local.region
  name = "news"
  gcf_name = module.gcf.frontend-api.name
}

output "lb_ip" {
  value = module.loadbalancer.ip
}