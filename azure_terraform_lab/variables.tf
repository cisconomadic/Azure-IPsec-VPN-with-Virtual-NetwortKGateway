############################################################
# Terraform Cloud Variables - Azure FortiGate Hybrid Lab
# Author: Jeremiah Eastwood
# Purpose: Variable definitions for hybrid Azure–FortiGate
############################################################

# ---------------------------
# General Configuration
# ---------------------------
variable "prefix" {
  description = "Prefix used for naming all resources."
  type        = string
}

variable "location" {
  description = "Azure region for resource deployment."
  type        = string
  default     = "centralus"
}

# ---------------------------
# Address Spaces & Subnets
# ---------------------------
variable "hub_address_space" {
  description = "Address space for the Azure hub virtual network."
  type        = list(string)
}

variable "hub_gateway_subnet" {
  description = "Subnet prefix for the hub GatewaySubnet."
  type        = string
}

variable "hub_workload_subnet" {
  description = "Subnet prefix for the hub workload subnet."
  type        = string
}

variable "onprem_address_space" {
  description = "Local address space for on-prem FortiGate network."
  type        = list(string)
}

variable "onprem_gateway_subnet" {
  description = "Subnet prefix for the on-prem simulated gateway."
  type        = string
}

variable "onprem_workload_subnet" {
  description = "Subnet prefix for on-prem workload network."
  type        = string
}

# ---------------------------
# BGP Configuration
# ---------------------------
variable "hub_asn" {
  description = "BGP ASN for Azure VPN Gateway."
  type        = number
  default     = 65010
}

variable "onprem_asn" {
  description = "BGP ASN for the on-prem FortiGate device."
  type        = number
  default     = 65020
}

variable "hub_bgp_ip" {
  description = "Azure VPN Gateway BGP peering IP (APIPA)."
  type        = string
  default     = "169.254.21.1"
}

variable "onprem_bgp_ip" {
  description = "FortiGate BGP peering IP (APIPA)."
  type        = string
  default     = "169.254.21.2"
}

# ---------------------------
# VPN Shared Key
# ---------------------------
variable "shared_key" {
  description = "Pre-shared key for IPsec VPN tunnel authentication."
  type        = string
  sensitive   = true
}

# ---------------------------
# IKE / IPsec Policy
# ---------------------------
variable "ike_encryption" {
  description = "IKE Phase 1 encryption algorithm."
  type        = string
  default     = "AES256"
}

variable "ike_integrity" {
  description = "IKE Phase 1 integrity algorithm."
  type        = string
  default     = "SHA256"
}

variable "ipsec_encryption" {
  description = "IPsec Phase 2 encryption algorithm."
  type        = string
  default     = "AES256"
}

variable "ipsec_integrity" {
  description = "IPsec Phase 2 integrity algorithm."
  type        = string
  default     = "SHA256"
}

variable "dh_group" {
  description = "Diffie-Hellman group for IKE negotiation."
  type        = string
  default     = "DHGroup2"
}

variable "pfs_group" {
  description = "Perfect Forward Secrecy group for IPsec Phase 2."
  type        = string
  default     = "PFS2"
}

variable "sa_lifetime_sec" {
  description = "Security Association lifetime in seconds."
  type        = number
  default     = 28000
}
