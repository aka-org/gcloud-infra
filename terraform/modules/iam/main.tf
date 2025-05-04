locals {
  # Iterate on local service accounts and
  # generate role bindings for all service accounts
  sa_role_bindings = flatten([
    for sa in var.service_accounts : [
      for role in sa.roles : {
        id      = sa.id
        role    = role
        project = var.project_id
      }
    ]
  ])

  # Determine which service accounts require
  # a key to be created
  sa_create_keys = [
    for sa in var.service_accounts : sa.id if sa.create_key
  ]

  # Determine which service accounts require
  # requires their private key to be stored in current work directory 
  sa_write_keys = [
    for sa in var.service_accounts : sa.id if sa.create_key && sa.write_key
  ]
}

resource "google_service_account" "sa" {
  for_each     = { for sa in var.service_accounts : sa.id => sa }
  account_id   = each.value.id
  display_name = each.value.description
}

resource "google_project_iam_member" "sa_role" {
  for_each = {
    for binding in local.sa_role_bindings :
    "${binding.id}-${binding.role}" => binding
  }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.sa[each.value.id].email}"
}

resource "google_service_account_key" "sa_key" {
  for_each = toset(local.sa_create_keys)

  service_account_id = google_service_account.sa[each.value].account_id
  keepers = {
    sa_email = google_service_account.sa[each.value].email
  }
}

resource "local_file" "sa_key_file" {
  for_each = toset(local.sa_write_keys)

  content  = google_service_account_key.sa_key[each.value].private_key
  filename = "${path.cwd}/${google_service_account.sa[each.value].account_id}-key.json"
}
