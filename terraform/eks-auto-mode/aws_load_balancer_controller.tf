locals {
  vpc_id = module.vpc.vpc_id
  namespace = "kube-system"

  load_balancer_controller_sa = "aws-load-balancer-controller"
  load_balancer_policy = file("${path.module}/iam_policy.json")
}

module "irsa_load_balancer_controller" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSLoadBalancerController"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [aws_iam_policy.load_balancer_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.namespace}:${local.load_balancer_controller_sa}"]
}

resource "aws_iam_policy" "load_balancer_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "EKS Load Balancer Controller Policy"

  policy = local.load_balancer_policy
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.10.0"

  namespace  = local.namespace

  depends_on = [module.eks]

  set {
    name  = "clusterName"
    value = local.name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa_load_balancer_controller.iam_role_arn
  }

  set {
    name  = "serviceAccount.name"
    value = local.load_balancer_controller_sa
  }

  set {
    name  = "region"
    value = local.region
  }

  set {
    name  = "vpcId"
    value = local.vpc_id
  }
}