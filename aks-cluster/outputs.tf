output "kube_config" {
  value     = azurerm_kubernetes_cluster.lights_on_heights_aks.kube_config_raw
  sensitive = true
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.lights_on_heights_log_analytics.id
}
