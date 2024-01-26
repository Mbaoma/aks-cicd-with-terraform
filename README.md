# aks-cicd-with-terraform
**Aim: DEPLOYMENT AND MANAGEMENT OF A MICROSERVICES-BASED APPLICATION USING TERRAFORM**.
This is a  a microservices-based web application that requires a scalable, secure infrastructure with a focus on automation and best practices in cloud infrastructure management. 

## Prerequisites
- Install and configure [Terraform](https://developer.hashicorp.com/terraform/install).
- Download [kubectl](https://kubernetes.io/releases/download/).

## Authentication
You need to authenticate Terraform to access your Azure account via CLI.
- Download the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos#install-with-homebrew)
- Login to your Azure account ([guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret))
```
$ az login
```

## Terraform Setup
- Code is modularized.
- Azure storage (blob) is used as backend for team collaboration, state locking, and state security.

## Terraform setup for AKS
When setting up the cluster, the aim is to ensure scalability, high availability, security, and best practices for cloud infrastructure management.
- Networking Setup: define a secure network boundary for your AKS cluster and related resources by creating a dedicated VNet and subnet(s) for your AKS cluster to ensure network isolation and control over IP address ranges.

- High Availability: deploy the AKS cluster across multiple availability zones. This ensures that your cluster remains operational even if one data center goes down.

- Scalability: configure the ```auto_scaler_profile``` within ```default_node_pool``` to enable cluster autoscaling.

- Storage and Persistence: set up persistent volume claims (PVCs) backed by Azure Disks or Azure Files for stateful workloads.

- Monitoring and Logging: Integrate Azure Monitor and Log Analytics for monitoring and logging capabilities. This ensures you have insights into the cluster's performance and can set up alerts based on specific metrics or logs.

## Git Workflow
- **Branching Strategy**: Adopt a strategy like Git Flow or GitHub Flow. For a microservices architecture, a simplified branch strategy might be more efficient, with main for stable releases, develop for ongoing development, and feature branches off develop.

- **Branch Naming**: Use descriptive names for branches, e.g., feature/add-login, bugfix/login-error.

- **Merging and Conflicts**: Prefer using pull requests for merging to facilitate code reviews. Resolve conflicts by merging the target branch into your feature branch and resolving locally.

## Running the CI/CD pipeline
- Create the secret ```AZURE_CREDENTIALS```

```
{
  "clientId": "<appId>",
  "clientSecret": "<password>",
  "subscriptionId": "<subscription-id>",
  "tenantId": "<tenant>"
}
```
- I have 2 files ```ci.yaml``` and ```cd.yaml``` for continuous integration (setup infrastructure using terraform), and continuous deployment (update AKS cluster with services).
I manage the order of workflow execution by setting up a dependency between the two workflow files using the ```workflow_run``` event in ```cd.yaml```.

## Monitoring, logging, and RBAC setup,