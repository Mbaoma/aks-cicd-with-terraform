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

variable "cluster_name" {
  description = "Name of the AKS cluster"
  default     = "lights_on_heights_cluster"
  type        = string
}

variable "cluster_dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  default     = "lights-on-heights-dns-prefix"
  type        = string
}

variable "log_analytics_workspace_sku" {
  description = "SKU for the Log Analytics workspace"
  default     = "PerGB2018"
  type        = string
}