resource "google_project_service" "apis" {
  for_each = toset(var.enable_apis)
  service = each.value
}
