output "vnet_id" {
  value = azurerm_virtual_network.lights_on_heights_vnet.id
}

output "subnet_id" {
  value = azurerm_subnet.lights_on_heights_subnet.id
}

output "nsg_id" {
  value = azurerm_network_security_group.lights_on_heights_sg.id
}