variable "project_id" {
  description = "The GCP project ID"
  type        = string
  sensitive   = true
  default     = ""
}
variable "project_name" {
  description = "A human-readable name for the project"
  type        = string
  default     = ""
}
variable "project_deletion_policy" {
  description = "Project deletion policy (e.g. PREVENT or DELETE)"
  type        = string
  default     = "PREVENT"
}
variable "billing_account_id" {
  description = "Billing account ID to associate with the project"
  type        = string
  sensitive   = true
  default     = ""
}
