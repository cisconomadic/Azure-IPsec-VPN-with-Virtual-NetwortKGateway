# Resource groups
resource "azurerm_resource_group" "hub_rg" {
  name     = "${var.prefix}-hub-rg"
  location = var.location
}

# Hub VNet
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${var.prefix}-hub-vnet"
  address_space       = ["10.10.0.0/16
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
}

resource "azurerm_subnet" "hub_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.10.255.0/27"]
}

resource "azurerm_subnet" "hub_workload" {
  name                 = "WorkloadSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}
