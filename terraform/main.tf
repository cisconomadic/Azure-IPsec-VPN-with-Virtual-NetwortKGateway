provider "azurerm" {
  features {}
}

variable "location" {
  description = "Azure region"
  default     = "East US"
}

variable "resource_group_name" {
  description = "Resource group name"
  default     = "ipsec-vpn-rg"
}
