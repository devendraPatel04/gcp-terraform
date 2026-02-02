resource "google_app_engine_application" "app" {
  count = var.create_app_engine ? 1 : 0

  project     = var.project_id
  location_id = var.app_engine_location_id
}

resource "google_app_engine_standard_app_version" "default" {
  count = contains([for s in var.app_engine_services : s.service_name], "default") ? 1 : 0

  project    = var.project_id
  service    = "default"
  version_id = var.app_engine_services["default"].version_id
  runtime    = var.app_engine_services["default"].runtime

  env_variables = try(var.app_engine_services["default"].env_vars, {})

  entrypoint {
    shell = var.app_engine_services["default"].entrypoint.shell
  }

  deployment {
    zip {
      source_url = var.app_engine_services["default"].source_url
    }
  }

  depends_on = [
    google_app_engine_application.app
  ]
}


resource "google_app_engine_standard_app_version" "service" {
  for_each = {
    for k, v in var.app_engine_services : k => v
    if v.service_name != "default"
  }

  project    = var.project_id
  service    = each.value.service_name
  version_id = each.value.version_id
  runtime    = each.value.runtime

  env_variables = try(each.value.env_vars, {})

  dynamic "entrypoint" {
    for_each = each.value.entrypoint != null ? [each.value.entrypoint] : [{
      shell = "npm start"
    }]

    content {
      shell = entrypoint.value.shell
    }
  }

  deployment {
    zip {
      source_url = each.value.source_url
    }
  }

  lifecycle {
    ignore_changes = [
      deployment,
      version_id
    ]
  }

  depends_on = [
    google_app_engine_standard_app_version.default
  ]
}
