variable "name" {
  type        = string
  default     = "lights_on_heights_aks_rg"
  description = "Resource group name for my assessment"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region to deploy resources"
}
