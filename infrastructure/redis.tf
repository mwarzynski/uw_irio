// It's expensive. Use only when you need to.
//resource "google_redis_instance" "frontend_cache" {
//  name           = "frontend-cache"
//  region         = local.region
//
//  memory_size_gb = 1
//  depends_on = [
//    google_project_service.redis
//  ]
//}
