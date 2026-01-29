resource "google_cloud_run_v2_service" "service" {
  for_each = var.services

  name     = each.value.name
  location = each.value.region
#   project  = var.project_id

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
      client,
      client_version,
      # You should also ignore annotations/labels if gcloud updates those
      labels,
      annotations,
      template[0].labels,
      template[0].annotations
    ]
  }

  template {
    containers {
      image = each.value.image
    }
  }
}

resource "google_cloud_run_v2_service_iam_binding" "invoker" {
  for_each = var.services

  location = google_cloud_run_v2_service.service[each.key].location
  name     = google_cloud_run_v2_service.service[each.key].name
  role     = "roles/run.invoker"

  members = try(each.value.public, false) ? ["allUsers"] : []

}

# resource "google_cloud_run_v2_service_iam_member" "public" {
#   count = try(var.services[var.service_key].public, false) ? 1 : 0

#   location = google_cloud_run_v2_service.service[var.service_key].location
#   name     = google_cloud_run_v2_service.service[var.service_key].name

#   role   = "roles/run.invoker"
#   member = "allUsers"
# }



# resource "google_cloud_run_v2_service_iam_member" "public" {
#   for_each = {
#     for k, v in var.services : k => v
#     if try(v.public, false)
#   }

# #   project  = var.project_id
#   location = google_cloud_run_v2_service.service[each.key].location
#   name     = google_cloud_run_v2_service.service[each.key].name

#   role   = "roles/run.invoker"
#   member = "allUsers"
# }
