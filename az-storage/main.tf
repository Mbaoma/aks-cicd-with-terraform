#reference the resource group module
module "resource_group" {
  source   = "../modules/resource_group"
  name     = var.name_rg
  location = var.location_rg
}

# Create a storage account
resource "azurerm_storage_account" "lights_on_heights_sg" {
    name                     = var.storage_account_name
    resource_group_name      = module.resource_group.name 
    location                 = module.resource_group.location 
    account_tier             = var.account_tier
    account_replication_type = var.account_replication_type
    account_kind              = var.account_kind 
    # public_network_access_enabled = false
    enable_https_traffic_only = true
}

# Create a storage container in the storage account
resource "azurerm_storage_container" "lights_on_heights_sc" {
  name                  = var.storage_account_container
  storage_account_name  = azurerm_storage_account.lights_on_heights_sg.name
  container_access_type = "private"
}

# Manages a resources Advanced Threat Protection setting.
resource "azurerm_advanced_threat_protection" "lights_on_heights_threat-protection" {
  target_resource_id = azurerm_storage_account.lights_on_heights_sg.id
  enabled            = true
}