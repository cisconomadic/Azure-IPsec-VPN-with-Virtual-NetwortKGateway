############################################################
# Terraform Cloud Outputs - Azure FortiGate Hybrid Lab
# Author: Jeremiah Eastwood
# Purpose: Summarize hybrid VPN deployment details
############################################################

# ---------------------------------------------------------
# General / Metadata
# ---------------------------------------------------------
output "deployment_region" {
  description = "Azure region where resources were deployed."
  value       = var.location
}

output "hub_resource_group" {
  description = "Resource group containing the Azure hub infrastructure."
  value       = azurerm_resource_group.hub_rg.name
}

output "hub_vnet_name" {
  description = "Name of the Azure hub virtual network."
  value       = azurerm_virtual_network.hub_vnet.name
}

# ---------------------------------------------------------
# Azure VPN Gateway Public IPs
# ---------------------------------------------------------
output "hub_public_ip_1" {
  description = "Primary public IP of the Azure VPN Gateway."
  value       = azurerm_public_ip.hub_pip1.ip_address
}

output "hub_public_ip_2" {
  description = "Secondary public IP (for Active/Active mode) of the Azure VPN Gateway."
  value       = azurerm_public_ip.hub_pip2.ip_address
}

# ---------------------------------------------------------
# FortiGate / Azure BGP Summary
# ---------------------------------------------------------
output "vpn_summary" {
  description = "Summary of key VPN/BGP parameters for FortiGate configuration."
  sensitive   = true
  value = {
    azure_public_ips    = [
      azurerm_public_ip.hub_pip1.ip_address,
      azurerm_public_ip.hub_pip2.ip_address
    ]
    azure_bgp_ip        = var.hub_bgp_ip
    azure_bgp_asn       = var.hub_asn
    fortigate_public_ip = var.onprem_public_ip != null ? var.onprem_public_ip : "FortiGate WAN IP"
    fortigate_bgp_ip    = var.onprem_bgp_ip
    fortigate_bgp_asn   = var.onprem_asn
    shared_key          = var.shared_key
  }
}

# ---------------------------------------------------------
# FortiGate Configuration Reference
# ---------------------------------------------------------
output "fortigate_cli_hint" {
  description = "Reference to the generated FortiGate VPN configuration template."
  value       = "See templates/fortigate_config.tpl for generated CLI"
}

# Optional: Path to the rendered configuration file (if using null_resource to render locally)
output "fortigate_config_path" {
  description = "Path to rendered FortiGate configuration file (if generated)."
  value       = "${path.module}/fortigate_config.txt"
}
