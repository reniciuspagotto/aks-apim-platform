terraform {
  required_version = ">= 1.15.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.12"
    }
  }

  backend "azurerm" {
    resource_group_name  = "IaC-Az-App-State"
    storage_account_name = "azappstatepagotto"
    container_name       = "aztfstate"
    key                  = "shared-poc.tfstate"
  }
}

provider "azurerm" {
  features {}
}
