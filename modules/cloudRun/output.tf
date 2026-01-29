output "cloud_run_services" {
  value = {
    for k, v in google_cloud_run_v2_service.service :
    k => {
      name     = v.name
      location = v.location
      uri      = v.uri
    }
  }
}
