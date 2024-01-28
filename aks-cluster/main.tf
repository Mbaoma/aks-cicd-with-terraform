# Create a resource group
resource "azurerm_resource_group" "lights_on_heights_aks_rg" {
  name     = var.rg_name
  location = var.rg_location
}

# Setup AKS cluster with RBAC and monitoring enabled
resource "azurerm_kubernetes_cluster" "lights_on_heights_aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.lights_on_heights_aks_rg.location
  resource_group_name = azurerm_resource_group.lights_on_heights_aks_rg.name
  dns_prefix          = var.cluster_dns_prefix

  default_node_pool {
    name                = "aksnp"
    node_count          = 1 # Initial node count
    vm_size             = "Standard_DS2_v2"
    enable_auto_scaling = true # Enable cluster autoscaler
    min_count           = 1    # Minimum number of nodes
    max_count           = 2    # Maximum number of nodes
  }

  role_based_access_control_enabled = true

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    load_balancer_sku  = "standard"  
    outbound_type      = "loadBalancer"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.lights_on_heights_log_analytics.id
  }
}

# Setup cluster monitoring
resource "azurerm_log_analytics_workspace" "lights_on_heights_log_analytics" {
  name                = "lights-on-heights-aks-logs"
  location            = azurerm_resource_group.lights_on_heights_aks_rg.location
  resource_group_name = azurerm_resource_group.lights_on_heights_aks_rg.name
  sku                 = var.log_analytics_workspace_sku
}

# Create a container registry to push the images to
resource "azurerm_container_registry" "lights_on_heights_acr" {
  name                = var.acr_registry_name
  resource_group_name = azurerm_resource_group.lights_on_heights_aks_rg.name
  location            = azurerm_resource_group.lights_on_heights_aks_rg.location
  sku                 = "Premium"
  admin_enabled       = false
}
