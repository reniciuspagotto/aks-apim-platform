output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "acr_name" {
  value = azurerm_container_registry.this.name
}

output "acr_login_server" {
  value = azurerm_container_registry.this.login_server
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "apim_name" {
  value = azurerm_api_management.this.name
}

output "apim_gateway_url" {
  value = azurerm_api_management.this.gateway_url
}

output "aks_kubelet_identity_client_id" {
  value = azurerm_user_assigned_identity.kubelet.client_id
}
