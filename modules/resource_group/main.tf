# Create a resource group
resource "azurerm_resource_group" "lights_on_heights_aks_rg" {
  name     = var.name
  location = var.location
}