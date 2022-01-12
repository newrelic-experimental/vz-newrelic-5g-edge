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

  nr_bundle_infra           = true
  nr_bundle_prometheus      = false
  nr_bundle_webhook         = false
  nr_bundle_ksm             = true
  nr_bundle_kube_events     = true
  nr_bundle_logging         = false
  nr_bundle_pixie           = true
  nr_bundle_pixie_chart     = true
  nr_bundle_infra_operator  = false
  nr_bundle_metrics_adapter = false
  patch_pixie               = true

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