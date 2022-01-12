terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.56"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 1.4"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.1"
    }
  }

}

data "terraform_remote_state" "wavelength" {
  backend = "local"
  config = {
    path = "../wavelength-cluster/terraform.tfstate"
  }
}

locals {
  cluster_name = data.terraform_remote_state.wavelength.outputs.cluster_name
  region       = "us-east-1"
}

################################################################################
# AWS provider configuration
################################################################################

provider "aws" {
  region = local.region
}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}


################################################################################
# Pixie
################################################################################

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

module "pixie" {
  source = "./pixie-nr-module"

  nr_bundle_infra           = true  # installs the New Relic Infrastructure Daemonset
  nr_bundle_prometheus      = false # installs the New Relic Prometheus OpenMetrics Integration
  nr_bundle_webhook         = false # installs the New Relic Metadata Injection Webhook
  nr_bundle_ksm             = true  # installs Kube State Metrics
  nr_bundle_kube_events     = true  # installs the New Relic Kubernetes Events Integration
  nr_bundle_logging         = false # installs the New Relic Logs Integration (Fluent-Bit)
  nr_bundle_pixie           = true  # installs the New Relic / Pixie Integration
  nr_bundle_pixie_chart     = true  # installs the Pixie Operator
  nr_bundle_infra_operator  = false # installs the New Relic Infrastructure Operator (Fargate-only)
  nr_bundle_metrics_adapter = false # installs the New Relic Metrics Adapter
  patch_pixie               = true  # enables the necessary patching so Pixie will run successfuly in a Wavelength cluster

  nr_license_key   = "<NR LICENSE KEY>"
  pixie_api_key    = "<PIXIE_API_KEY>"
  pixie_deploy_key = "<PIXIE_DEPLOY_KEY>"
  cluster_name     = local.cluster_name

  kubernetes_host_info = {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}