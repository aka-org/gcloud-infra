module "project" {
  source  = "aka-org/project/google"
  version = "1.0.0"

  project_name       = var.project_name
  project_labels     = var.project_labels
  billing_account_id = var.billing_account_id
  bucket_name_prefix = var.bucket_name_prefix
  bucket_labels      = var.bucket_labels
  gcs_backend        = var.gcs_backend
  gha_wif_enabled    = var.gha_wif_enabled
  gha_owner_id       = var.gha_owner_id
  gha_allowed_repos  = var.gha_allowed_repos
  vpc_create         = var.vpc_create
  vpc_name           = var.vpc_name
}
