locals {
  kafka_endpoint = var.kafka_endpoint

  endpoint = format("[\"%s\"]", replace(local.kafka_endpoint, ",", "\",\""))
}

data "kubectl_path_documents" "filebeat" {
  pattern = "./filebeat/*.yaml"

  vars = {
    cluster_name   = local.name
    kafka_endpoint = local.endpoint
  }
}

resource "kubectl_manifest" "filebeat" {
  for_each = data.kubectl_path_documents.filebeat.manifests
  yaml_body = each.value
}