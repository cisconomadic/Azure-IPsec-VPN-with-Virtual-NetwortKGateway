variable "location" {
  type        = string
  default     = "centralus"
  description = "Azure region for deployment."
}

variable "prefix" {
  type    = string
  default = "hybridlab"
}

variable "shared_key" {
  type        = string
  default     = "HybridLab123!"
  description = "Pre-shared key for the IPsec VPN connection."
}

# ---------------------------------------------------------
# Gateway Mode
# ---------------------------------------------------------
variable "active_active" {
  type        = bool
  default     = false
  description = "Enables Active-Active mode for Azure VPN Gateway."
}

# ---------------------------------------------------------
# BGP Configuration
# ---------------------------------------------------------
variable "hub_asn" {
  type        = number
  default     = 65010
  description = "BGP ASN for the Hub (Corp) VPN Gateway."
}

variable "onprem_asn" {
  type        = number
  default     = 65020
  description = "BGP ASN for the On-Prem (simulated) VPN Gateway."
}

# Optional: use APIPA peering addresses (commonly used with IPsec/BGP)
variable "use_apipa" {
  type        = bool
  default     = false
  description = "If true, set APIPA peering addresses explicitly on gateways."
}

variable "hub_apipa" {
  type        = list(string)
  default     = ["169.254.21.1"]
  description = "APIPA BGP peering address(es) for Hub (if use_apipa=true)."
}

variable "onprem_apipa" {
  type        = list(string)
  default     = ["169.254.21.2"]
  description = "APIPA BGP peering address(es) for On-Prem (if use_apipa=true)."
}

# ---------------------------------------------------------
# On-Prem (FortiGate) and LAN Variables
# ---------------------------------------------------------
variable "onprem_public_ip" {
  type        = string
  default     = "68.12.118.55"
  description = "Public IP of the On-Prem FortiGate WAN interface."
}

variable "onprem_address_space" {
  type        = list(string)
  default     = ["192.168.0.0/16"]
  description = "Local address space(s) behind the On-Prem firewall."
}

# ---------------------------------------------------------
# IKE/IPsec Crypto Policy Configuration
# ---------------------------------------------------------
variable "ike_encryption" {
  type        = string
  default     = "AES256"
  description = "IKE (Phase 1) encryption algorithm."
}

variable "ike_integrity" {
  type        = string
  default     = "SHA256"
  description = "IKE (Phase 1) integrity algorithm."
}

variable "ipsec_encryption" {
  type        = string
  default     = "AES256"
  description = "IPsec (Phase 2) encryption algorithm."
}

variable "ipsec_integrity" {
  type        = string
  default     = "SHA256"
  description = "IPsec (Phase 2) integrity algorithm."
}

variable "dh_group" {
  type        = string
  default     = "DHGroup2"
  description = "Diffie-Hellman group used during IKE (Phase 1)."
}

variable "pfs_group" {
  type        = string
  default     = "PFS2"
  description = "Perfect Forward Secrecy group used during IPsec (Phase 2)."
}

variable "sa_lifetime_sec" {
  type        = number
  default     = 28000
  description = "Security Association lifetime in seconds for both phases."
}

variable "sa_data_size_kb" {
  type        = number
  default     = 102400000
  description = "Max data size (KB) before rekeying."
}

# ---------------------------------------------------------
# BGP Peering IP Addresses (APIPA)
# ---------------------------------------------------------
variable "hub_bgp_ip" {
  type        = string
  default     = "169.254.21.1"
  description = "BGP peering IP address on Azure Hub side."
}

variable "onprem_bgp_ip" {
  type        = string
  default     = "169.254.21.2"
  description = "BGP peering IP address on FortiGate On-Prem side."
}
