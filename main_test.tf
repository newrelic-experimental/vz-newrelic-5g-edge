data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks_cluster_id
}

provider "aws" {
  region = var.region
}

module "pixie" {
    source = "./pixie-newrelic"
    
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = data.aws_eks_cluster.eks.certificate_authority[0].data
    token                  = data.aws_eks_cluster_auth.eks.token
    nr_license_key         = "testing-123"
    pixie_api_key          = "testing-123"
    pixie_deploy_key       = "testing-123"
}