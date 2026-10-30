data "azurerm_container_registry" "shared" {
  name                = local.shared_acr_name
  resource_group_name = local.shared_resource_group_name
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = local.aks_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  dns_prefix          = local.aks_name
  sku_tier            = "Standard"

  default_node_pool {
    name       = "system"
    node_count = var.aks_node_count
    vm_size    = var.aks_node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  node_provisioning_profile {
    mode = "Manual"
  }

  web_app_routing {
    dns_zone_ids             = []
    default_nginx_controller = "External"
  }
}

# Nodes pull images from the shared ACR using the kubelet identity created by AKS
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                            = data.azurerm_container_registry.shared.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}
