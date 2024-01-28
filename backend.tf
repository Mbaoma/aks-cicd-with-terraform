terraform {
  backend "azurerm" {
    resource_group_name  = "lights_on_heights_remote_backend"
    storage_account_name = "l1ght5onhe1ghts"
    container_name       = "l1ght5onhe1ghtsc0nta1ner"
    key                  = "aks-cluster-2/terraform.tfstate"
  }
}