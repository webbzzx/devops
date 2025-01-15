resource "helm_release" "metrics-server" {
  name       = "metrics-server"

  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"

  namespace  = "kube-system"

  depends_on = [module.eks]

  set {
    name  = "addonResizer.enabled"
    value = "true"
  }

  set {
    name  = "addonResizer.resources.limits.cpu"
    value = "100m"
  }

  set {
    name  = "addonResizer.resources.limits.memory"
    value = "100Mi"
  }

  # set {
  #   name  = "addonResizer.extraCPU"
  #   value = "2m"
  # }

  # set {
  #   name  = "addonResizer.nanny.extraMemory"
  #   value = "5Mi"
  # }

  # set {
  #   name  = "resources.limits.cpu"
  #   value = "500m"
  # }

  # set {
  #   name  = "resources.limits.memory"
  #   value = "1000Mi"
  # }
}