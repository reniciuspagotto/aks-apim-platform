variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus2"
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
