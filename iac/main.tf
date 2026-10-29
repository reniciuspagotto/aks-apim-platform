data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_container_registry" "this" {
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.tags
}

# Control plane identity of the AKS cluster
resource "azurerm_user_assigned_identity" "aks" {
  name                = local.aks_identity_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = var.tags
}

# Kubelet identity used by the nodes to pull images from ACR
resource "azurerm_user_assigned_identity" "kubelet" {
  name                = local.kubelet_id_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = var.tags
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
  scope                            = azurerm_container_registry.this.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.kubelet.principal_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = local.aks_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  dns_prefix          = local.aks_name
  kubernetes_version  = var.kubernetes_version
  sku_tier            = "Free"

  default_node_pool {
    name                        = "system"
    node_count                  = var.aks_node_count
    vm_size                     = var.aks_node_vm_size
    os_disk_size_gb             = 64
    temporary_name_for_rotation = "systemtmp"

    upgrade_settings {
      max_surge = "10%"
    }
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

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
    network_policy      = "cilium"
    load_balancer_sku   = "standard"
  }

  tags = var.tags

  depends_on = [
    azurerm_role_assignment.aks_kubelet_operator,
    azurerm_role_assignment.kubelet_acr_pull,
  ]
}

# The pipeline identity running Terraform pushes images to ACR
resource "azurerm_role_assignment" "deployer_acr_push" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPush"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_api_management" "this" {
  name                = local.apim_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = "Developer_1"
  tags                = var.tags
}
