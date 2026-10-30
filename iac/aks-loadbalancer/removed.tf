removed {
  from = azurerm_resource_group.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = azurerm_container_registry.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = azurerm_role_assignment.deployer_acr_push

  lifecycle {
    destroy = false
  }
}

removed {
  from = azurerm_api_management.this

  lifecycle {
    destroy = false
  }
}
