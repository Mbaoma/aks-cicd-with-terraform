# Create a resource group
resource "azurerm_resource_group" "lights_on_heights_rg" {
  name     = var.rg_name
  location = var.rg_location
}