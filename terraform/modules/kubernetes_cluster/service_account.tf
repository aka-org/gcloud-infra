resource "google_service_account" "sa" {
  #  project      = google_project.project.project_id 
  account_id   = local.sa_id
  display_name = local.sa_id
}

resource "google_project_iam_member" "sa_role" {
  for_each = {
    for binding in local.sa_role_bindings :
    "${binding.sa_id}-${binding.role}" => binding
  }

  #  project = google_project.project.project_id
  role   = each.value.role
  member = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_service_account_key" "sa_key" {
  for_each = local.sa_create_keys

  service_account_id = google_service_account.sa.name
  keepers = {
    sa_email = google_service_account.sa.email
  }
}

resource "local_file" "sa_key_file" {
  for_each = local.sa_create_keys

  content  = google_service_account_key.sa_key[local.sa_id].private_key
  filename = "${path.cwd}/${google_service_account.sa.display_name}-key.json"
}
