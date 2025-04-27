locals {
  secrets = {
    for secret in var.secrets : secret.id => secret
  }
  versioned_secrets = {
    for secret in var.secrets : secret.id => secret if secret.add_version
  }
}

resource "google_secret_manager_secret" "secret" {
  for_each = local.secrets

  secret_id = each.value.id
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  for_each = local.versioned_secrets

  secret      = google_secret_manager_secret.secret[each.value.id].id
  secret_data = var.secret_values[each.value.id]
}
