
resource "google_service_account" "tf_auth_manager" {
  account_id = "tf-auth-manager"
  display_name = "Bootstrap authentication manager"
}

resource "google_service_account_iam_binding" "tf_auth_manager" {
  service_account_id = google_service_account.tf_auth_manager.name
  role = "roles/iam.workloadIdentityUser"
  members = [
    "principal://iam.googleapis.com/${google_iam_workload_identity_pool.identity_pool.name}/subject/${local.auth_tf_workspace}",
  ]
}


resource "google_project_iam_member" "tf_auth_manager" {
  project = data.google_project.project.project_id
  for_each = toset([
    "roles/iam.workloadIdentityPoolAdmin",
    "roles/iam.roleAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin"
  ])
  role    = each.key
  member  = google_service_account.tf_auth_manager.member
}
