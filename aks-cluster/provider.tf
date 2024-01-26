variable "client_secret" {
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  use_oidc = true
  # subscription_id = "f8db0501-e2fe-49e4-abfa-e70745b53732"
  # client_id       = "62e1e1a8-360e-4eea-a0ea-e8d5c32aafaa"
  # client_secret   = "${var.client_secret}"
  # tenant_id       = "25f0918c-9e0d-4b24-975f-cd91e6b937ef"
  features {}
}