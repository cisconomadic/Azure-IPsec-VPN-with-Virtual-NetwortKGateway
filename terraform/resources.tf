resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "ipsec-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_public_ip" "vpn1" {
  name                = "vpn-gateway-pip1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_public_ip" "vpn2" {
  name                = "vpn-gateway-pip2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_virtual_network_gateway" "vpn" {
  name                = "ipsec-vnet-gateway"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig1"
    public_ip_address_id          = azurerm_public_ip.vpn1.id
    subnet_id                     = azurerm_subnet.gateway.id
    private_ip_address_allocation = "Dynamic"
  }

  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.vpn2.id
    subnet_id                     = azurerm_subnet.gateway.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_local_network_gateway" "onprem" {
  name                = "onprem-local-gateway"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  gateway_address     = "203.0.113.1" # Replace with on-premises public IP
  address_space       = ["10.2.0.0/16"] # Replace with on-premises address space
}

resource "azurerm_virtual_network_gateway_connection" "vpnconn" {
  name                            = "vpn-connection"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vpn.id
  local_network_gateway_id        = azurerm_local_network_gateway.onprem.id
  type                            = "IPsec"
  connection_protocol             = "IKEv2"
  shared_key                      = "SuperSecretSharedKey123" # Replace with your shared key
}
