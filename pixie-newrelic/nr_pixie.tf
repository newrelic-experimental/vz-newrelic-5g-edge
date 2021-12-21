data "template_file" "pixie_values" {
  template = file("${path.module}/templates/values.yaml")

  vars = {
    CLUSTER_NAME              = var.cluster_name
    NR_BUNDLE_INFRA           = var.nr_bundle_infra
    NR_BUNDLE_PROMETHEUS      = var.nr_bundle_prometheus
    NR_BUNDLE_WEBHOOK         = var.nr_bundle_webhook
    NR_BUNDLE_KSM             = var.nr_bundle_ksm
    NR_BUNDLE_KUBE_EVENTS     = var.nr_bundle_kube_events
    NR_BUNDLE_LOGGING         = var.nr_bundle_logging
    NR_BUNDLE_PIXIE           = var.nr_bundle_pixie
    NR_BUNDLE_PIXIE_CHART     = var.nr_bundle_pixie_chart
    NR_BUNDLE_INFRA_OPERATOR  = var.nr_bundle_infra_operator
    NR_BUNDLE_METRICS_ADAPTER = var.nr_bundle_metrics_adapter
    PATCH_PIXIE               = var.patch_pixie
    PIXIE_PATCHES             = var.patch_pixie ? "${indent(4, file("${path.module}/templates/pixie-patches.yaml"))}" : "{}"
    NR_PIXIE_API_KEY          = var.nr_bundle_pixie ? var.pixie_api_key : ""
    NR_PIXIE_DEPLOY_KEY       = var.nr_bundle_pixie_chart ? var.pixie_deploy_key : ""
    NR_PIXIE_CLUSTER_NAME     = var.nr_bundle_pixie_chart ? var.cluster_name : ""
    NR_LICENSE_KEY            = var.nr_license_key
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
  count = var.patch_pixie ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl patch deployments coredns -n kube-system -p '{\"spec\": {\"template\": {\"spec\": {\"nodeSelector\": {\"pixie.io/components\": \"true\"}}}}}'"

    environment = {
      #KUBECONFIG = module.eks_cluster.kubeconfig_filename
      #KUBECONFIG = "/Users/bschmitt/newrelic/git-repos/vz-newrelic-5g-edge/wavelength-cluster/kubeconfig_wavelength-test"
      KUBECONFIG = var.kube_config_path
      # KUBESERVER = var.kubernetes_host_info["host"]
      # KUBETOKEN  = var.kubernetes_host_info["token"]
      # KUBECA     = base64decode(var.kubernetes_host_info["cluster_ca_certificate"])
    }
  }

  # depends_on = [
  #   aws_autoscaling_group.wavelength_workers
  # ]
}

resource "null_resource" "patch_pixie" {
  count = var.patch_pixie ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl patch deployments newrelic-bundle-kube-state-metrics -n newrelic -p '{\"spec\": {\"template\": {\"spec\": {\"nodeSelector\": {\"pixie.io/components\": \"true\"}}}}}' && kubectl patch deployments catalog-operator -n olm -p '{\"spec\": {\"template\": {\"spec\": {\"nodeSelector\": {\"pixie.io/components\": \"true\"}}}}}' && kubectl patch deployments olm-operator -n olm -p '{\"spec\": {\"template\": {\"spec\": {\"nodeSelector\": {\"pixie.io/components\": \"true\"}}}}}' && kubectl patch deployments vizier-operator -n px-operator -p '{\"spec\": {\"template\": {\"spec\": {\"nodeSelector\": {\"pixie.io/components\": \"true\"}}}}}'"

    environment = {
      #KUBECONFIG = module.eks_cluster.kubeconfig_filename
      KUBECONFIG = var.kube_config_path
      # KUBESERVER = var.kubernetes_host_info["host"]
      # KUBETOKEN  = var.kubernetes_host_info["token"]
      # KUBECA     = base64decode(var.kubernetes_host_info["cluster_ca_certificate"])
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
      #KUBECONFIG = module.eks_cluster.kubeconfig_filename
      #KUBECONFIG = "../wavelength-cluster/kubeconfig_wavelength-test
      KUBECONFIG = var.kube_config_path
      #KUBESERVER = var.kubernetes_host_info["host"]
      #KUBETOKEN  = var.kubernetes_host_info["token"]
      #KUBECA     = base64decode(var.kubernetes_host_info["cluster_ca_certificate"])
    }
  }
  # depends_on = [
  #   null_resource.patch_coredns
  # ]
}


resource "helm_release" "newrelic" {
  name             = "newrelic-bundle"
  repository       = "https://helm-charts.newrelic.com"
  chart            = "nri-bundle"
  namespace        = "newrelic"
  create_namespace = true
  depends_on = [
    null_resource.apply_pixie
  ]

  values = [
    #file("${path.module}/values-test.yaml")
    #file("${path.module}/values.yaml")
    data.template_file.pixie_values.rendered
  ]

}