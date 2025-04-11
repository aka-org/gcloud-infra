variable "project_id" {
  description = "The GCP project ID"
  type        = string
  sensitive   = true
}
variable "project_name" {
  description = "A human-readable name for the project"
}
variable "project_deletion_policy" {
  description = "Project deletion policy (e.g. PREVENT or DELETE)"
  default     = "PREVENT"
}
variable "billing_account_id" {
  description = "Billing account ID to associate with the project"
  type        = string
  sensitive   = true
}

# SSH & Access
variable "admin_ssh_keys" {
  description = "SSH keys to be added to the instances"
}
