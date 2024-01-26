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

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "Storage account tier"
}

variable "account_replication_type" {
  type        = string
  default     = "LRS"
  description = "Storage account replication type"
}

variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "Storage account kind"
}

variable "storage_account_name" {
  type        = string
  default     = "l1ght5onhe1ghts"
  description = "Storage account name"
}

variable "storage_account_container" {
  type        = string
  default     = "l1ght5onhe1ghtsc0nta1ner"
  description = "Storage account container name"
}