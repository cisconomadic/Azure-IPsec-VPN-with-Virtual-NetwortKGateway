# =====================================================================
# OUTPUTS.TF — Key Outputs for Azure Hub + FortiGate Integration
# =====================================================================

# ---------------------------------------------------------------------
# Hub Resource Outputs
# ---------------------------------------------------------------------
output "hub_resource_group" {
  description = "Resource Group for the Hub deployment"
  value       = azurerm_resource_group.hub_rg.name
}

output "hub_vnet_name" {
  description = "Virtual Network Name for the Hub"
  value       = azurerm_virtual_network.hub_vnet.name
}

output "hub_public_ip_1" {
  description = "Azure VPN Gateway Public IP (Instance 1)"
  value       = azurerm_public_ip.hub_pip1.ip_address
}

output "hub_public_ip_2" {
  description = "Azure VPN Gateway Public IP (Instance 2)"
  value       = azurerm_public_ip.hub_pip2.ip_address
}

# ---------------------------------------------------------------------
# BGP + FortiGate Peering Info
# ---------------------------------------------------------------------
output "vpn_summary" {
  description = "Summarized VPN and BGP information for FortiGate configuration"
  value = {
    azure_bgp_asn = var.hub_asn
    azure_bgp_ip  = var.hub_bgp_ip
    azure_public_ips = [
      azurerm_public_ip.hub_pip1.ip_address,
      azurerm_public_ip.hub_pip2.ip_address
    ]
    fortigate_public_ip = var.onprem_public_ip
    fortigate_bgp_asn   = var.onprem_asn
    fortigate_bgp_ip    = var.onprem_bgp_ip
    shared_key          = var.shared_key
  }
  sensitive = true
}

# ---------------------------------------------------------------------
# Optional - Convenience Outputs
# ---------------------------------------------------------------------
output "fortigate_cli_hint" {
  description = "Command to generate FortiGate config template"
  value       = "See templates/fortigate_config.tpl for generated CLI"
}

output "deployment_region" {
  description = "Azure region used for the deployment"
  value       = var.location
}
