# Resource Group Module Reference
module "resource_group" {
  source   = "../modules/resource_group"
  name     = var.name_rg
  location = var.location_rg
}

module "networking" {
  source      = "../modules/networking"
  subnet_name = var.subnet_name
}

resource "azurerm_kubernetes_cluster" "lights_on_heights_aks" {
  name                = var.cluster_name
  location            = var.location_rg
  resource_group_name = var.name_rg
  dns_prefix          = var.cluster_dns_prefix

  default_node_pool {
    name            = "aks-node-pool"
    node_count      = 3  # Initial node count
    vm_size         = "Standard_DS2_v2"
    vnet_subnet_id  = module.networking.subnet_id
    enable_auto_scaling = true  # Enable cluster autoscaler
    min_count       = 1  # Minimum number of nodes
    max_count       = 5  # Maximum number of nodes
  }

  role_based_access_control_enabled = true

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }

    oms_agent {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.lights_on_heights_log_analytics.id
    }
}

resource "azurerm_log_analytics_workspace" "lights_on_heights_log_analytics" {
  name                = "lights-on-heights-aks-logs"
  location            = var.location_rg
  resource_group_name = var.name_rg
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_cluster" "lights_on_heights_log_analytics_cluster" {
  name                = "lights-on-heights-analytics-cluster"
  resource_group_name = var.name_rg
  location            = var.location_rg

  identity {
    type = "SystemAssigned"
  }
}
