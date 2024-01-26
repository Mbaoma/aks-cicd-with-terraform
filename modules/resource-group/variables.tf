variable "rg_name" {
  type        = string
  default     = "lights-on-heights-24"
  description = "Resource group name for my assessment"
}

variable "rg_location" {
  type        = string
  default     = "eastus"
  description = "Azure region to deploy resources"
}
