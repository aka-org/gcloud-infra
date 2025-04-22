locals {
  sa_role_bindings = flatten([
    for sa in var.service_accounts : [
      for role in sa.roles : {
        sa_id = sa.id
        role  = role
      }
    ]
  ])
  sa_create_keys = {
    for sa in var.service_accounts :
    sa.id => sa
    if sa.create_key
  }
}

resource "google_service_account" "sa" {
  for_each     = { for sa in var.service_accounts : sa.id => sa }
  account_id   = each.value.id
  display_name = each.value.display_name
}

resource "google_project_iam_member" "sa_role" {
  for_each = {
    for binding in local.sa_role_bindings :
    "${binding.sa_id}-${binding.role}" => binding
  }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.sa[each.value.sa_id].email}"
}

resource "google_service_account_key" "sa_key" {
  for_each = local.sa_create_keys

  service_account_id = google_service_account.sa[each.value.id].account_id
  keepers = {
    sa_email = google_service_account.sa[each.value.id].email
  }
}

resource "local_file" "sa_key_file" {
  for_each = local.sa_create_keys

  content  = google_service_account_key.sa_key[each.value.id].private_key
  filename = "${path.cwd}/${google_service_account.sa[each.value.id].display_name}-key.json"
}
