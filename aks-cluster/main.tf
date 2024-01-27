resource "azurerm_resource_group" "lights_on_heights_aks_rg" {
  name     = var.rg_name
  location = var.rg_location
}

module "networking" {
  source      = "../modules/networking"
  subnet_name = var.subnet_name
}

resource "azurerm_kubernetes_cluster" "lights_on_heights_aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.lights_on_heights_aks_rg.location
  resource_group_name = azurerm_resource_group.lights_on_heights_aks_rg.name
  dns_prefix          = var.cluster_dns_prefix

  default_node_pool {
    name                = "aksnp"
    node_count          = 3 # Initial node count
    vm_size             = "Standard_DS2_v2"
    vnet_subnet_id      = module.networking.subnet_id
    enable_auto_scaling = true # Enable cluster autoscaler
    min_count           = 1    # Minimum number of nodes
    max_count           = 5    # Maximum number of nodes
  }

  role_based_access_control_enabled = true

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    service_cidr       = "10.1.0.0/16"
    dns_service_ip     = "10.1.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.lights_on_heights_log_analytics.id
  }
}

resource "azurerm_log_analytics_workspace" "lights_on_heights_log_analytics" {
  name                = "lights-on-heights-aks-logs"
  location            = azurerm_resource_group.lights_on_heights_aks_rg.location
  resource_group_name = azurerm_resource_group.lights_on_heights_aks_rg.name
  sku                 = var.log_analytics_workspace_sku
}
