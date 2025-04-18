variable "secrets_map" {
  type      = map(string)
  sensitive = true
  description = "Map of secret name => secret value"
  default = {}
}
