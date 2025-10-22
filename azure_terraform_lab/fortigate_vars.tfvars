# ---------------------------------------------------------
# Azure Hybrid VPN with FortiGate – Shared Variables
# ---------------------------------------------------------

# ---------- General ----------
prefix     = "hybridlab"
location   = "centralus"
shared_key = "HybridLab123!"

# ---------- BGP Parameters ----------
hub_asn    = 65010 # Azure ASN
onprem_asn = 65020 # FortiGate ASN

# APIPA Peering Addresses
hub_bgp_ip    = "169.254.21.1"
onprem_bgp_ip = "169.254.21.2"

# ---------- On-Prem (FortiGate) ----------
onprem_public_ip     = "68.12.118.55"     # Your FortiGate WAN IP
onprem_address_space = ["192.168.0.0/16"] # Local LAN behind FortiGate

# ---------- VPN Gateway Mode ----------
active_active = true

# ---------- IKE/IPsec Parameters ----------
ike_encryption   = "AES256"
ike_integrity    = "SHA256"
ipsec_encryption = "AES256"
ipsec_integrity  = "SHA256"
dh_group         = "DHGroup2"
pfs_group        = "PFS2"
sa_lifetime_sec  = 28000
sa_data_size_kb  = 102400000
