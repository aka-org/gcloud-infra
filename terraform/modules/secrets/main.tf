resource "google_secret_manager_secret" "secret" {
  for_each = toset(var.secret_ids)

  secret_id = each.key

  replication {
    user_managed {
      replicas {
      location = var.secrets_location 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  for_each = toset(var.secret_ids)

  secret      = google_secret_manager_secret.secret[each.key].id
  secret_data = var.secrets_map[each.key] 
}
