import {
  to = azurerm_resource_group.this
  id = "/subscriptions/563efcd7-bd1e-41de-b5c3-6950a9b7d863/resourceGroups/rg-aznetapp-poc"
}

import {
  to = azurerm_container_registry.this
  id = "/subscriptions/563efcd7-bd1e-41de-b5c3-6950a9b7d863/resourceGroups/rg-aznetapp-poc/providers/Microsoft.ContainerRegistry/registries/acraznetapppoc"
}

import {
  to = azurerm_role_assignment.deployer_acr_push
  id = "/subscriptions/563efcd7-bd1e-41de-b5c3-6950a9b7d863/resourceGroups/rg-aznetapp-poc/providers/Microsoft.ContainerRegistry/registries/acraznetapppoc/providers/Microsoft.Authorization/roleAssignments/9042fcd8-a595-0bcf-18f9-b4ecd7458693"
}

import {
  to = azurerm_api_management.this
  id = "/subscriptions/563efcd7-bd1e-41de-b5c3-6950a9b7d863/resourceGroups/rg-aznetapp-poc/providers/Microsoft.ApiManagement/service/apim-aznetapp-poc"
}
