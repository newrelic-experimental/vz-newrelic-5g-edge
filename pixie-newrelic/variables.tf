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

variable "cluster_name" {
  type    = string
  default = "wavelength-test"
}

variable "profile" {
  type        = string
  description = "AWS Credentials Profile to use"
  default     = "default"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "This is the AWS region."
}