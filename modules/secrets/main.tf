resource "google_secret_manager_secret" "secret" {
  for_each = var.secrets_map

  secret_id = each.key
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  for_each    = var.secrets_map
  secret      = google_secret_manager_secret.secret[each.key].id
  secret_data = each.value
}
