output "services" {
  value = {
    for k, v in google_app_engine_standard_app_version.service :
    k => {
      service = v.service
      version = v.version_id
    }
  }
}
