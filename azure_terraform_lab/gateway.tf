resource "azurerm_public_ip" "hub_pip1" {
  name                = "${var.prefix}-hub-pip1"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "hub_pip2" {
  name                = "${var.prefix}-hub-pip2"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "hub_gw" {
  name                = "${var.prefix}-hub-gw"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"
  enable_bgp          = true
  active_active       = true

  ip_configuration {
    name                          = "hub-gw-ipconfig1"
    public_ip_address_id          = azurerm_public_ip.hub_pip1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_gateway.id
  }

  ip_configuration {
    name                          = "hub-gw-ipconfig2"
    public_ip_address_id          = azurerm_public_ip.hub_pip2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_gateway.id
  }

  bgp_settings {
    asn = var.hub_asn

    peering_addresses {
      apipa_addresses       = [var.hub_bgp_ip]
      ip_configuration_name = "hub-gw-ipconfig1"
    }

    peering_addresses {
      apipa_addresses       = [var.hub_bgp_ip]
      ip_configuration_name = "hub-gw-ipconfig2"
    }
  }
}
