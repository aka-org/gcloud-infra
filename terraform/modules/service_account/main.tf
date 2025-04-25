locals {
  sa_role_bindings = [
    for role in var.service_account.roles : {
      sa_id = var.service_account.id
      role  = role
    }
  ]

  sa_create_keys = var.service_account.create_key ? {
    "${var.service_account.id}" = var.service_account
  } : {}
}

resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = var.service_account.id
  display_name = var.service_account.display_name
}

resource "google_project_iam_member" "sa_role" {
  for_each = {
    for binding in local.sa_role_bindings :
    "${binding.sa_id}-${binding.role}" => binding
  }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_service_account_key" "sa_key" {
  for_each = local.sa_create_keys

  service_account_id = google_service_account.sa.account_id
  keepers = {
    sa_email = google_service_account.sa.email
  }
}

resource "local_file" "sa_key_file" {
  for_each = local.sa_create_keys

  content  = google_service_account_key.sa_key[var.service_account.id].private_key
  filename = "${path.cwd}/${google_service_account.sa.display_name}-key.json"
}

output "email" {
  value = google_service_account.sa.email
}
