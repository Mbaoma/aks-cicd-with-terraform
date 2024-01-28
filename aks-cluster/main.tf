#create a resource group
resource "azurerm_resource_group" "lights_on_heights_aks_rg" {
  name     = var.rg_name
  location = var.rg_location
}

#reference networking modeule
module "networking" {
  source      = "../modules/networking"
  subnet_name = var.subnet_name
}

# Public IP for AKS Load Balancer
resource "azurerm_public_ip" "aks_lb_public_ip" {
  name                = "aks-public-ip"
  location            = azurerm_resource_group.lights_on_heights_aks_rg.location
  resource_group_name = azurerm_resource_group.lights_on_heights_aks_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Setup AKS Cluster with RBAC and Monitoring enabled
resource "azurerm_kubernetes_cluster" "lights_on_heights_aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.lights_on_heights_aks_rg.location
  resource_group_name = azurerm_resource_group.lights_on_heights_aks_rg.name

  default_node_pool {
    name                = "aksnp"
    node_count          = 1
    vm_size             = "Standard_DS2_v2"
    vnet_subnet_id      = module.networking.subnet_id
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 2
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
    load_balancer_profile {
      outbound_ip_address_ids = [azurerm_public_ip.aks_lb_public_ip.id]
    }
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.lights_on_heights_log_analytics.id
  }
}

# setup cluster with RBAC and monitoring enabled
# resource "azurerm_kubernetes_cluster" "lights_on_heights_aks" {
#   name                = var.cluster_name
#   location            = azurerm_resource_group.lights_on_heights_aks_rg.location
#   resource_group_name = azurerm_resource_group.lights_on_heights_aks_rg.name
#   dns_prefix          = var.cluster_dns_prefix

#   default_node_pool {
#     name                = "aksnp"
#     node_count          = 1 # Initial node count
#     vm_size             = "Standard_DS2_v2"
#     vnet_subnet_id      = module.networking.subnet_id
#     enable_auto_scaling = true # Enable cluster autoscaler
#     min_count           = 1    # Minimum number of nodes
#     max_count           = 2    # Maximum number of nodes
#   }

#   role_based_access_control_enabled = true

#   identity {
#     type = "SystemAssigned"
#   }

  # network_profile {
  #   network_plugin = "azure"
  #   network_policy = "calico"
  #   service_cidr       = "10.1.0.0/16"
  #   dns_service_ip     = "10.1.0.10"
  #   docker_bridge_cidr = "172.17.0.1/16"
  # }

#   network_profile {
#     network_plugin     = "azure"
#     network_policy     = "calico"
#     load_balancer_sku  = "standard"  # Standard load balancer for public IP
#   }

#   oms_agent {
#     log_analytics_workspace_id = azurerm_log_analytics_workspace.lights_on_heights_log_analytics.id
#   }
# }

# Setup Cluster Monitoring
resource "azurerm_log_analytics_workspace" "lights_on_heights_log_analytics" {
  name                = "lights-on-heights-aks-logs"
  location            = azurerm_resource_group.lights_on_heights_aks_rg.location
  resource_group_name = azurerm_resource_group.lights_on_heights_aks_rg.name
  sku                 = var.log_analytics_workspace_sku
}

# Create Container Registry to push the images to
resource "azurerm_container_registry" "lights_on_heights_acr" {
  name                = var.acr_registry_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = "Premium"
  admin_enabled       = false
}