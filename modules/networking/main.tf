# Resource Group Module Reference
module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.name_rg
  location = var.location_rg
}

# Virtual Network Resource
resource "azurerm_virtual_network" "lights_on_heights_vnet" {
  name                = var.vnet_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  address_space       = var.vnet_address_space
  dns_servers         = var.dns_servers
}

# Network Security Group Resource
resource "azurerm_network_security_group" "lights_on_heights_sg" {
  name                = var.network_sg_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  # Existing inbound rule
  security_rule {
    name                       = "allow-aks-required-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443", "22", "53"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  # Example outbound rule to allow all outbound traffic
  security_rule {
    name                       = "allow-all-outbound"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Subnet Resource
resource "azurerm_subnet" "lights_on_heights_subnet" {
  name                 = var.subnet_name
  resource_group_name  = module.resource_group.name
  virtual_network_name = azurerm_virtual_network.lights_on_heights_vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

# Association between Subnet and Network Security Group
resource "azurerm_subnet_network_security_group_association" "lights_on_heights_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.lights_on_heights_subnet.id
  network_security_group_id = azurerm_network_security_group.lights_on_heights_sg.id
}