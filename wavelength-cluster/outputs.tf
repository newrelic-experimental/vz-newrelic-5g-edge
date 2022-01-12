output "cluster_name" {
  value = data.aws_eks_cluster.cluster.id
  description = "Cluster name"
}