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
- The folder ```az-storage```, has its own resource group and is managed manually
```
terraform init
terraform validate
terraform plan
terraform apply
```
- All other resources needed to create the AKS cluster, are located in a different resource group and managed by CI runs.

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
- Create [secrets](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Clinux) to give [Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret.html) permission to access your Azure account.

- I have 2 files ```ci.yaml``` and ```cd.yaml``` for continuous integration (setup infrastructure using terraform), and continuous deployment (update AKS cluster with services).

## Kubernetes Deployment
- Enable [oidc](https://learn.microsoft.com/en-us/azure/aks/use-oidc-issuer) on the Kubernetes Cluster
- Authenticate GitHub Actions to [deploy](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azp) your Kubernetes manifests in clusters

<img width="1440" alt="image" src="https://github.com/Mbaoma/aks-cicd-with-terraform/assets/49791498/f10d3cde-b3aa-48a9-a1be-e4143ade71c8">

## Monitoring
- [Monitoring](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=terraform), is managed by agents - Azure Container Insights (in this case). I setup this agent using Terraform, however further configuration can be done in the Azure UI, to set what exact metrics to track and setup alerts.
```
oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.lights_on_heights_log_analytics.id
  }
```
- RBAC, was setup, using Terraform to limit who has access to the cluster.
```
role_based_access_control_enabled = true
```

<img width="1440" alt="image" src="https://github.com/Mbaoma/aks-cicd-with-terraform/assets/49791498/4d074862-b732-47b7-8566-894fe96cdf99">

<img width="917" alt="image" src="https://github.com/Mbaoma/aks-cicd-with-terraform/assets/49791498/757abb69-e99d-4bb0-91fc-3dbf589638cc">

<img width="1440" alt="image" src="https://github.com/Mbaoma/aks-cicd-with-terraform/assets/49791498/7ae16a18-1f55-4be8-a747-7c2207762fa0">

## Challenges
- I struggled with granting permission to Terraform to authenticate to Azure via GitHub actions but resolved it by reading documentation and checking StackOverflow.