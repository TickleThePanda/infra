
resource "google_service_account" "tf_location_history_manager" {
  account_id = "tf-location-history-manager"
  display_name = "Location history manager"
}

resource "google_service_account_iam_binding" "tf_location_history_manager" {
  service_account_id = google_service_account.tf_location_history_manager.name
  role = "roles/iam.workloadIdentityUser"
  members = [
    "principal://iam.googleapis.com/${google_iam_workload_identity_pool.identity_pool.name}/subject/${local.location_history_tf_workspace}",
  ]
}


resource "google_project_iam_member" "tf_location_history_manager" {
  project = data.google_project.project.project_id
  for_each = toset([
    "roles/run.developer",
    "roles/compute.loadBalancerAdmin",
    "roles/storage.admin",
    "roles/compute.publicIpAdmin",
    "roles/certificatemanager.editor",
    "roles/artifactregistry.admin"
  ])
  role    = each.key
  member  = google_service_account.tf_location_history_manager.member
}
