variable "name_rg" {
  type        = string
  default     = "lights_on_heights_24"
  description = "Resource group name for my assessment"
}

variable "location_rg" {
  type        = string
  default     = "eastus"
  description = "Azure region to deploy resources"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  default     = "lights_on_heights_vnet"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  default     = ["10.0.0.0/16"]
  type        = list(string)
}

variable "dns_servers" {
  description = "Custom DNS servers for the virtual network"
  default     = ["10.0.0.4", "10.0.0.5"]
  type        = list(string)
}

variable "network_sg_name" {
  description = "Name of the network security group"
  default     = "lights_on_heights_network_sg"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  default     = "lights_on_heights_subnet"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Address prefix for the subnet"
  default     = ["10.0.1.0/24"]
  type        = list(string)
}