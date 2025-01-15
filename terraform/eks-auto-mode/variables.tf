variable "region" {
  type = string
  default = "ap-southeast-1"
  description = "region"
}

variable "cluster_name" {
  type = string
  default = "aws-eks"
  description = "eks cluster name"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
  description = "vpc cidr"
}

variable "cluster_version" {
  type = string
  default = "1.31"
  description = "cluster version"
}

variable "sg_ingress_cidr" {
  description = "The security group ingress cidr of vpn address."
  type        = list(string)
  default     = []
}

variable "kafka_endpoint" {
  description = "Filebeat for logging."
  type        = any
  default     = ""
}