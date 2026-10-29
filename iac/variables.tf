variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus2"
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version. Null uses the region default."
  type        = string
  default     = null
}

variable "aks_node_count" {
  description = "Number of nodes in the AKS system node pool."
  type        = number
  default     = 1
}

variable "aks_node_vm_size" {
  description = "VM size for the AKS system node pool."
  type        = string
  default     = "Standard_D2s_v5"
}

variable "apim_publisher_name" {
  description = "API Management publisher name."
  type        = string
  default     = "aznetapp"
}

variable "apim_publisher_email" {
  description = "API Management publisher email."
  type        = string
  default     = "renicius.pagotto@outlook.com"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default = {
    project     = "az-app-aks-apim"
    environment = "poc"
  }
}
