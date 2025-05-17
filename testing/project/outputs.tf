output "project_id" {
  description = "The id of the project"
  value       = module.project.project_id
}

output "identity_provider_github_id" {
  description = "Workload identity provider for Github Actions"
  value       = module.project.identity_provider_github_id
}

output "identity_provider_github_full_id" {
  description = "Full path of workload identity provider for Github Actions"
  value       = module.project.identity_provider_github_full_id
}
