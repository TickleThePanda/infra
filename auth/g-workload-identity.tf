
resource "google_iam_workload_identity_pool" "identity_pool" {
  workload_identity_pool_id   = "pool"
  display_name                = "pool"
  description                 = "Global pool"
  disabled                    = false
}   

resource "google_iam_workload_identity_pool_provider" "terraform_pool_provider" {
  workload_identity_pool_id             = google_iam_workload_identity_pool.identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id    = "terraform-cloud-oidc-prod"
  display_name                          = "terraform-cloud-oidc-prod"
  description                           = "Terraform Cloud OIDC Provider"
  disabled                              = false

  attribute_mapping = {
    "attribute.tfc_organization_id"       = "assertion.terraform_organization_id"
    "attribute.tfc_project_id"            = "assertion.terraform_project_id"
    "attribute.tfc_project_name"          = "assertion.terraform_project_name"
    "google.subject"                      = "assertion.terraform_workspace_id"
    "attribute.tfc_workspace_name"        = "assertion.terraform_workspace_name"
  }

  oidc {
    issuer_uri = "https://app.terraform.io"
  }

  attribute_condition =  "attribute.tfc_organization_id == '${local.tf_organisation_id}'"
}


resource "google_iam_workload_identity_pool_provider" "github_pool_provider" {
  project  = data.google_project.project.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_condition = "assertion.repository_owner=='TickleThePanda'"
}