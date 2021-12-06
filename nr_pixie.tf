provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# resource "null_resource" "check_nodes" {
#     provisioner "local-exec" {
#       command = "./check_nodes.sh"

#       environment = {
#         KUBECONFIG = module.eks_cluster.kubeconfig_filename
#       }
#     }

#     depends_on = [
#       aws_autoscaling_group.wavelength_workers
#     ]
# }

resource "null_resource" "patch_coredns" {
  provisioner "local-exec" {
    command = "kubectl patch deployments coredns -n kube-system -p '{\"spec\": {\"template\": {\"spec\": {\"nodeSelector\": {\"pixie.io/components\": \"true\"}}}}}'"

    environment = {
      KUBECONFIG = module.eks_cluster.kubeconfig_filename
    }
  }

  depends_on = [
    aws_autoscaling_group.wavelength_workers
  ]
}

resource "null_resource" "patch_pixie" {
  provisioner "local-exec" {
    command = "kubectl patch deployments newrelic-bundle-kube-state-metrics -n newrelic -p '{\"spec\": {\"template\": {\"spec\": {\"nodeSelector\": {\"pixie.io/components\": \"true\"}}}}}' && kubectl patch deployments catalog-operator -n olm -p '{\"spec\": {\"template\": {\"spec\": {\"nodeSelector\": {\"pixie.io/components\": \"true\"}}}}}' && kubectl patch deployments olm-operator -n olm -p '{\"spec\": {\"template\": {\"spec\": {\"nodeSelector\": {\"pixie.io/components\": \"true\"}}}}}' && kubectl patch deployments vizier-operator -n px-operator -p '{\"spec\": {\"template\": {\"spec\": {\"nodeSelector\": {\"pixie.io/components\": \"true\"}}}}}'"

    environment = {
      KUBECONFIG = module.eks_cluster.kubeconfig_filename
    }
  }
  depends_on = [
    helm_release.newrelic
  ]
}

resource "null_resource" "apply_pixie" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://download.newrelic.com/install/kubernetes/pixie/latest/px.dev_viziers.yaml && kubectl apply -f https://download.newrelic.com/install/kubernetes/pixie/latest/olm_crd.yaml"

    environment = {
      KUBECONFIG = module.eks_cluster.kubeconfig_filename
    }
  }
  depends_on = [
    null_resource.patch_coredns
  ]
}

resource "helm_release" "newrelic" {
  name             = "newrelic-bundle"
  repository       = "https://helm-charts.newrelic.com"
  chart            = "nri-bundle"
  namespace        = "newrelic"
  create_namespace = true
  depends_on = [
    null_resource.apply_pixie,
    aws_autoscaling_group.wavelength_workers
  ]

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "global.licenseKey"
    value = var.nr_license_key
  }

  set {
    name  = "global.cluster"
    value = var.cluster_name
  }

  set {
    name  = "newrelic-pixie.apiKey"
    value = var.pixie_api_key
  }

  set {
    name  = "pixie-chart.deployKey"
    value = var.pixie_deploy_key
  }

  set {
    name  = "pixie-chart.clusterName"
    value = var.cluster_name
  }
}