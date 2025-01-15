resource "kubectl_manifest" "efs_sc" {
  yaml_body = <<YAML
  kind: StorageClass
  apiVersion: storage.k8s.io/v1
  metadata:
    name: efs-sc
  provisioner: efs.csi.aws.com
  parameters:
    provisioningMode: efs-ap
    fileSystemId: ${aws_efs_file_system.efs.id}
    directoryPerms: "700"
    gidRangeStart: "1000" # optional
    gidRangeEnd: "2000" # optional
    basePath: "/k8s/share" # optional
    ensureUniqueDirectory: "true" # optional
    reuseAccessPoint: "false" # optional
  YAML
}
