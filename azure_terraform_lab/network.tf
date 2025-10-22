resource "azurerm_resource_group" "hub_rg" {
  name     = "${var.prefix}-hub-rg"
  location = var.location
}

resource "azurerm_resource_group" "onprem_rg" {
  name     = "${var.prefix}-onprem-rg"
  location = var.location
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${var.prefix}-hub-vnet"
  address_space       = var.hub_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_rg.name
}

resource "azurerm_subnet" "hub_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [var.hub_gateway_subnet]
}

resource "azurerm_subnet" "hub_workload" {
  name                 = "WorkloadSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [var.hub_workload_subnet]
}

resource "azurerm_virtual_network" "onprem_vnet" {
  name                = "${var.prefix}-onprem-vnet"
  address_space       = var.onprem_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.onprem_rg.name
}

resource "azurerm_subnet" "onprem_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.onprem_rg.name
  virtual_network_name = azurerm_virtual_network.onprem_vnet.name
  address_prefixes     = [var.onprem_gateway_subnet]
}

resource "azurerm_subnet" "onprem_workload" {
  name                 = "WorkloadSubnet"
  resource_group_name  = azurerm_resource_group.onprem_rg.name
  virtual_network_name = azurerm_virtual_network.onprem_vnet.name
  address_prefixes     = [var.onprem_workload_subnet]
}
