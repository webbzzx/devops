# EKS Auto Mode

## Usage

To provision the provided configurations you need to execute:

```bash
terraform init
terraform plan
terraform apply --auto-approve
```

Once the cluster has finished provisioning, you can use the `kubectl` command to interact with the cluster. For example, to deploy a sample deployment and see EKS Auto Mode in action, run:

```bash
aws eks update-kubeconfig --name $(terraform output -raw cluster_name)
kubectl apply -f deployment.yaml
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
