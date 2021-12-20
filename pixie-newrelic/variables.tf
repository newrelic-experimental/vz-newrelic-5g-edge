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

variable "eks_cluster_id" {
  type    = string
  default = "none"
}

variable "profile" {
  type        = string
  description = "AWS Credentials Profile to use"
  default     = "default"
}

variable "kube_config_path" {
  type        = string
  description = "(optional) describe your variable"
  default     = "~/.kube/config"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "This is the AWS region."
}

###### Helm Chart Values #######

variable "nr_bundle_infra" {
  type        = bool
  description = "Install NewRelic Infrastructure Agent"
  default     = true
}

variable "nr_bundle_prometheus" {
  type        = bool
  description = "Install NewRelic Prometheus"
  default     = false
}

variable "nr_bundle_webhook" {
  type        = bool
  description = "Install NewRelic Webhook"
  default     = false
}

variable "nr_bundle_ksm" {
  type        = bool
  description = "Install NewRelic Kube State Metrics"
  default     = true
}

variable "nr_bundle_kube_events" {
  type        = bool
  description = "Install NewRelic Kube Events"
  default     = true
}

variable "nr_bundle_logging" {
  type        = bool
  description = "Install NewRelic Logging"
  default     = false
}

variable "nr_bundle_pixie" {
  type        = bool
  description = "Install NewRelic Pixie"
  default     = false
}

variable "nr_bundle_pixie_chart" {
  type        = bool
  description = "Install NewRelic Pixie Chart"
  default     = false
}

variable "nr_bundle_infra_operator" {
  type        = bool
  description = "Install NewRelic Infrastructure Operator"
  default     = false
}

variable "nr_bundle_metrics_adapter" {
  type        = bool
  description = "Install NewRelic Metrics Adapter"
  default     = false
}

variable "patch_pixie" {
  type        = bool
  description = "Patch the nodes with Pixie Setting"
  default     = false
}

###### Kubernetes Host Info Mapping #######
variable "kubernetes_host_info" {
  type = map(any)
  default = {
    host                   = "test"
    cluster_ca_certificate = "Y2FfY2VydF9kYXRhCg=="
    token                  = "token"
  }
}