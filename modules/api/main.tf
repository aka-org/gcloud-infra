resource "google_project_service" "enabled_api" {
  for_each = toset(var.enable_apis)
  service = each.value
}
