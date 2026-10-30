data "azurerm_resource_group" "shared" {
  name = local.shared_resource_group_name
}

data "azurerm_container_registry" "shared" {
  name                = local.shared_acr_name
  resource_group_name = local.shared_resource_group_name
}

# This cluster already runs with user-assigned identities; kubelet_identity cannot change without recreating it
resource "azurerm_user_assigned_identity" "aks" {
  name                = local.aks_identity_name
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = data.azurerm_resource_group.shared.location
}

resource "azurerm_user_assigned_identity" "kubelet" {
  name                = local.kubelet_id_name
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = data.azurerm_resource_group.shared.location
}

# Required for AKS to assign a user-assigned kubelet identity to the nodes
resource "azurerm_role_assignment" "aks_kubelet_operator" {
  scope                            = azurerm_user_assigned_identity.kubelet.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = azurerm_user_assigned_identity.aks.principal_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "kubelet_acr_pull" {
  scope                            = data.azurerm_container_registry.shared.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.kubelet.principal_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = local.aks_name
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = data.azurerm_resource_group.shared.location
  dns_prefix          = local.aks_name
  sku_tier            = "Standard"

  default_node_pool {
    name       = "system"
    node_count = var.aks_node_count
    vm_size    = var.aks_node_vm_size
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.kubelet.id
  }

  node_provisioning_profile {
    mode = "Manual"
  }

  depends_on = [
    azurerm_role_assignment.aks_kubelet_operator,
    azurerm_role_assignment.kubelet_acr_pull,
  ]
}
