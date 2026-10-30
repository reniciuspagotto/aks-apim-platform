variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus2"
}

variable "aks_node_count" {
  description = "Number of nodes in the AKS system node pool."
  type        = number
  default     = 2
}

variable "aks_node_vm_size" {
  description = "VM size for the AKS system node pool."
  type        = string
  default     = "Standard_D2s_v5"
}
