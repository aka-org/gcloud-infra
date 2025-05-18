output "project_id" {
  description = "The id of the project"
  value       = module.project.project_id
}

output "sa_email" {
  description = "Default service account email"
  value       = module.project.sa_email
}

output "sa_id" {
  description = "Default service account id"
  value       = module.project.sa_id
}

output "identity_provider_github_full_ids" {
  description = "Full path of workload identity provider for Github Actions"
  value       = module.project.identity_provider_github_full_ids
}

output "vpc_name" {
  description = "Name of the project vpc"
  value       = module.project.vpc_name
}

output "vpc_self_link" {
  description = "Self link to the project vpc"
  value       = module.project.vpc_self_link
}
