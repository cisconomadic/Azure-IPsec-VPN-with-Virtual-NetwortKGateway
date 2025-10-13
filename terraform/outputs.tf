output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "virtual_network_gateway_id" {
  value = azurerm_virtual_network_gateway.vpn.id
}

output "local_network_gateway_id" {
  value = azurerm_local_network_gateway.onprem.id
}

output "vpn_connection_id" {
  value = azurerm_virtual_network_gateway_connection.vpnconn.id
}

output "public_ip_1" {
  value = azurerm_public_ip.vpn1.ip_address
}

output "public_ip_2" {
  value = azurerm_public_ip.vpn2.ip_address
}
