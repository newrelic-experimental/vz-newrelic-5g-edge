variable "nr_license_key" {
  description = "New Relic License Key"
  sensitive   = true
}

variable "pixie_api_key" {
  description = "Pixie API Key found in New Relic Guided Install"
  sensitive   = true
}

variable "pixie_deploy_key" {
  description = "Pixie Deploy Key found in New Relic Guided Install"
  sensitive   = true
}