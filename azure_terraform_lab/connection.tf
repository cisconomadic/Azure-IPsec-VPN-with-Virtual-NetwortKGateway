# =====================================================================
# CONNECTION.TF — Azure Hub ↔ On-Prem FortiGate (Physical)
# =====================================================================

# ---------------------------------------------------------------------
# Local Network Gateway (represents your on-prem FortiGate device)
# ---------------------------------------------------------------------
resource "azurerm_local_network_gateway" "hub_lng" {
  name                = "${var.prefix}-hub-lng"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  gateway_address     = var.onprem_public_ip     # Example: 68.12.118.55
  address_space       = var.onprem_address_space # Example: ["192.168.0.0/16"]

  bgp_settings {
    asn                 = var.onprem_asn    # Example: 65020
    bgp_peering_address = var.onprem_bgp_ip # Example: 169.254.21.2
  }
}

# ---------------------------------------------------------
# Site-to-Site VPN Connection (Azure <-> FortiGate)
# Based on ARM Template Equivalent
# ---------------------------------------------------------

resource "azurerm_virtual_network_gateway_connection" "hub_to_onprem" {
  name                = "${var.prefix}-hub-to-onprem"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  type                       = "IPsec"
  connection_protocol        = "IKEv2"
  connection_mode            = "Default"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub_gw.id
  local_network_gateway_id   = azurerm_local_network_gateway.hub_lng.id
  shared_key                 = "Ilovethisnetwork2"



  # While ARM supports gatewayCustomBgpIpAddresses, Terraform sets these through the gateway itself
  # BGP peering addresses are already defined under `bgp_settings` in your hub_gw block.

  depends_on = [
    azurerm_virtual_network_gateway.hub_gw,
    azurerm_local_network_gateway.hub_lng
  ]
}


# ---------------------------------------------------------------------
# Output FortiGate Config Template (optional)
# ---------------------------------------------------------------------
resource "local_file" "fortigate_config" {
  depends_on = [azurerm_virtual_network_gateway.hub_gw]

  content = templatefile("${path.module}/templates/fortigate_config.tpl", {
    vpn_public_ip_1   = azurerm_public_ip.hub_pip1.ip_address
    vpn_public_ip_2   = azurerm_public_ip.hub_pip2.ip_address
    shared_key        = var.shared_key
    hub_asn           = var.hub_asn
    onprem_asn        = var.onprem_asn
    onprem_lan_prefix = var.onprem_address_space[0]
    azure_bgp_ip      = var.hub_bgp_ip
    fortigate_bgp_ip  = var.onprem_bgp_ip
    ike_encryption    = var.ike_encryption
    ike_integrity     = var.ike_integrity
    ipsec_encryption  = var.ipsec_encryption
    ipsec_integrity   = var.ipsec_integrity
    dh_group          = var.dh_group
    pfs_group         = var.pfs_group
    sa_lifetime_sec   = var.sa_lifetime_sec
  })

  filename = "${path.module}/fortigate_config.txt"
}
