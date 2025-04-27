output "service_accounts" {
  value = [
    for sa in local.service_accounts : {
      email     = google_service_account.sa[sa.id].email
      assign_to = sa.assign_to
    }
  ]
}
