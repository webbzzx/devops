resource "helm_release" "kube-prometheus-stack" {
  name       = "kube-prometheus-stack"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  namespace  = "monitoring"
  create_namespace = true

  depends_on = [module.eks]

  values = [
    "${file("prometheus/values-eks-mng.yaml")}"
  ]
}