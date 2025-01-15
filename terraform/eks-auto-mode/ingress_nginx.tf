################################################
# Security group with complete set of arguments
################################################
# module "complete_sg" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "ingress-nginx-sg"
#   description = "Security group with ingress-nginx-sg"
#   vpc_id      = module.vpc.default_vpc_id

#   use_name_prefix = false

#   ingress_cidr_blocks = ["0.0.0.0/0"]
#   ingress_rules       = ["http-80-tcp", "https-443-tcp"]

#   # Default CIDR blocks, which will be used for all egress rules in this module. Typically these are CIDR blocks of the VPC.
#   # If this is not specified then no CIDR blocks will be used.
#   egress_cidr_blocks = ["0.0.0.0/0"]

#   # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
#   egress_with_cidr_blocks = [
#     {
#       from_port   = -1
#       to_port     = -1
#       protocol    = -1
#       description = "All protocols"
#     }
#   ]
# }

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace  = "ingress-nginx"
  create_namespace = true

  depends_on = [helm_release.aws_load_balancer_controller]

  values = [
    <<-EOT
    controller:
      config:
        log-format-escape-json: "true"
        log-format-upstream: >-
          {"@timestamp": "$time_iso8601","remote_addr":
          "$remote_addr","x-forward-for": "$proxy_add_x_forwarded_for","request_id":
          "$req_id","remote_user": "$remote_user","bytes_sent":
          "$bytes_sent","request_time": "$request_time","status":
          "$status","request_host": "$host","request_protocol":
          "$server_protocol","request_uri": "$uri","args": "$args","request_length":
          "$request_length","duration": "$request_time","request_method":
          "$request_method","http_referer": "$http_referer","http_user_agent":
          "$http_user_agent","server_addr":"$server_addr","upstream_addr":
          "$upstream_addr","upstream_response_time":"$upstream_response_time","proxy_upstream_name":
          "$proxy_upstream_name","upstream_status": "$upstream_status"}
      autoscaling:
        enabled: true
      replicaCount: 3
      service:
        enabled: true
        externalTrafficPolicy: Local
        annotations: 
          service.beta.kubernetes.io/aws-load-balancer-target-group-attributes: deregistration_delay.timeout_seconds=270,preserve_client_ip.enabled=true
          service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
          service.beta.kubernetes.io/aws-load-balancer-healthcheck-path: /healthz
          service.beta.kubernetes.io/aws-load-balancer-healthcheck-port: "10254"
          service.beta.kubernetes.io/aws-load-balancer-healthcheck-protocol: http
          service.beta.kubernetes.io/aws-load-balancer-healthcheck-success-codes: 200-299
          service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
          service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
          service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
          service.beta.kubernetes.io/aws-load-balancer-type: nlb
          service.beta.kubernetes.io/aws-load-balancer-subnets: ${join(",", module.vpc.public_subnets)}
    EOT
  ]
}