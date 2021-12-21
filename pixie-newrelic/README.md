# NewRelic Pixie/NR Bundle Helm Deployment

Usage (for EKS):
```bash
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
      source = "gavinbunney/kubectl"
      version = ">= 1.13.1"
    }
  }
}


locals {
    cluster_name = "cluster_name"
}

################################################################################
# AWS provider configuration
################################################################################

provider "aws" {
  region = "us-east-1"
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
  source = "../../vz-newrelic-5g-edge/pixie-newrelic"

  nr_bundle_infra           = true
  nr_bundle_prometheus      = true
  nr_bundle_webhook         = true
  nr_bundle_ksm             = true
  nr_bundle_kube_events     = true
  nr_bundle_logging         = true
  nr_bundle_pixie           = true
  nr_bundle_pixie_chart     = true
  nr_bundle_infra_operator  = false
  nr_bundle_metrics_adapter = false
  patch_pixie = true

  nr_license_key   = "nrkeyxxxxxxx"
  pixie_api_key    = "px-api-xxxxx"
  pixie_deploy_key = "px-dep-xxxxx"
  cluster_name     = "cluster-name"
  kubernetes_host_info = {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

```