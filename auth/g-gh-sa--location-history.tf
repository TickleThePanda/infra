
resource "google_service_account" "location_history_image_pusher" {
  account_id = "location-history-docker"
  display_name = "Can push location history images"
}

resource "google_service_account_iam_binding" "location_history_image_pusher" {
  service_account_id = google_service_account.location_history_image_pusher.name
  role = "roles/iam.workloadIdentityUser"
  members = [
    "principal://iam.googleapis.com/${google_iam_workload_identity_pool.identity_pool.name}/subject/repo:TickleThePanda/location-history",
  ]
}


resource "google_project_iam_member" "location_history_image_pusher" {
  project = data.google_project.project.project_id
  for_each = toset([
    "roles/artifactregistry.writer"
  ])
  role    = each.key
  member  = google_service_account.location_history_image_pusher.member
}
