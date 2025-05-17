module "project" {
  source  = "aka-org/project/google"
  version = "0.3.0"

  project_name            = var.project_name
  project_labels          = var.project_labels
  project_deletion_policy = var.project_deletion_policy
  billing_account_id      = var.billing_account_id
  enable_apis             = var.enable_apis
  bucket                  = var.bucket
  gcs_backend             = var.gcs_backend
  service_accounts        = var.service_accounts
  gha_wif_enabled         = var.gha_wif_enabled
  gha_wif_sa              = var.gha_wif_sa
  gha_wif_org             = var.gha_wif_org
  gha_wif_repo            = var.gha_wif_repo
  create_vpc              = var.create_vpc
  vpc_name                = var.vpc_name
}
