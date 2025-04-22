# Secrets
variable "secrets_location" {
  type        = string
  description = "Secret replication location"
  default     = "us-east1"
}
variable "secrets_map" {
  type        = map(string)
  sensitive   = true
  description = "Map of secret name => secret value"
  default     = {}
}
variable "secret_ids" {
  description = "List of secret ids"
  type        = list(string)
  default     = []
}
