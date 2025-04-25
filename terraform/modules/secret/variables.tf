# Generic Project settings
variable "project_id" {
  description = " The GCP Project id"
  type        = string
}
# Secrets
variable "secret_id" {
  description = "Secret to be created"
  type        = string
}
variable "secret_data" {
  description = "Value of Secret"
  type        = string
  sensitive   = true
  default     = ""
}
