# Service Account
variable "sa_id" {
  description = "The ID for the service account (e.g., 'terraform-sa')"
  type        = string
  default     = ""
}
variable "sa_display_name" {
  description = "Display name for the service account"
  type        = string
  default     = ""
}
variable "sa_project_id" {
  description = "ID of the project that the service account will be associated with"
  type        = string
  default     = ""
}
variable "sa_roles" {
  description = "List of IAM roles to bind to the service account"
  type        = list(string)
  default = []
}
