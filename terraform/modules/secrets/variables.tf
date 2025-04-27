# Secrets
variable "secrets" {
  description = "List of Secret objects to be created"
  type        = list(object({
    id = string
    add_version = bool
  }))
}
variable "secret_values" {
  description = "Map of secret key-value pairs"
  type        = map(string)
  sensitive   = true
  default     = {}
}     
