resource "google_service_account" "sa" {
  account_id   = var.sa_id
  display_name = var.sa_display_name
}

resource "google_project_iam_member" "sa_roles" {
  for_each = toset(var.sa_roles)

  project  = var.sa_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.sa.name
  keepers = {
    sa_email = google_service_account.sa.email
  }
}

resource "local_file" "sa_key_file" {
  content  = google_service_account_key.sa_key.private_key
  filename = "${path.cwd}/${google_service_account.sa.display_name}-key.json"
}
