# 🌐 Azure ↔ FortiGate Hybrid VPN (Terraform + GitHub Actions)

![Terraform](https://img.shields.io/badge/Terraform-1.6.0-blue?logo=terraform)
![Azure](https://img.shields.io/badge/Azure-Cloud%20Network-blue?logo=microsoft-azure)
![Fortinet](https://img.shields.io/badge/Fortinet-FortiGate-red?logo=fortinet)
![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-black?logo=github-actions)

---

## 🧭 Overview

This repository automates the deployment of a **hybrid site-to-site IPsec VPN** between **Microsoft Azure** and an **on-prem FortiGate firewall** using **Terraform** and **GitHub Actions CI/CD**.

The project builds:
- An **Azure Virtual Network Gateway** (Active/Active, BGP-enabled)
- A **Local Network Gateway** representing your FortiGate
- A **bi-directional IPsec VPN connection**
- A dynamically rendered **FortiGate CLI configuration** template

After deployment, the FortiGate CLI configuration (`fortigate_config.txt`) is automatically generated and uploaded as an artifact in your GitHub Actions workflow.

---

## 🧩 Architecture

+----------------------+ +--------------------------+
| Azure Cloud | | On-Premises |
|----------------------| |--------------------------|
| VNET: 10.10.0.0/16 | IPsec VPN | LAN: 192.168.0.0/16 |
| GW Subnet: .255.0/27|<================>| FortiGate (WAN IP: X.X.X.X)
| Workload: .1.0/24 | BGP Peering | ASN: 65020 |
| ASN: 65010 | 169.254.21.1/2 | APIPA: 169.254.21.2 |
+----------------------+ +--------------------------+


**Key Features**
- 🔁 Dual Azure public IPs for active/active VPN
- 🔐 IPsec with AES256/SHA256 and DH/PFS2
- 📡 Dynamic BGP peering using APIPA range (169.254.x.x)
- 🧱 Terraform-managed IaC with modular files
- 🤖 Automated validation, planning, and apply via GitHub Actions
- 🧩 Auto-generated FortiGate configuration

---

## 🗂️ Project Folder Structure

```bash
azure_terraform_lab/
│
├── 📄 main.tf                      # Terraform backend + provider definitions
├── 📄 variables.tf                 # Input variables (ASNs, encryption, etc.)
├── 📄 outputs.tf                   # Deployment outputs (public IPs, keys, etc.)
├── 📄 network.tf                   # Hub + On-Prem VNETs and subnets
├── 📄 gateway.tf                   # Azure VPN Gateway (Active/Active + BGP)
├── 📄 connection.tf                # VPN connections + FortiGate config generation
│
├── 📄 fortigate_vars.tfvars        # Environment-specific variable overrides
│
├── 📁 templates/                   # Template directory for generated device configs
│   └── 🧩 fortigate_config.tpl      # FortiGate CLI template rendered by Terraform
│
├── 📁 .github/
│   └── 📁 workflows/
│       ├── ⚙️ terraform-ci.yml      # CI: Validate + Plan + Upload tfplan
│       └── 🚀 terraform-apply.yml   # CD: Apply + Upload FortiGate config
│
├── 🧾 README.md                    # Project overview (this file)
└── 🔒 .gitignore                   # Excludes .tfstate, tfplan, and sensitive files

⚙️ GitHub Actions Workflows
Workflow	Purpose
terraform-ci.yml	Runs on push/PR → validates formatting, runs terraform plan, uploads the plan as an artifact
terraform-apply.yml	Runs manually or on merge → executes terraform apply, deploys infrastructure, and uploads the generated fortigate_config.txt

Artifacts Uploaded:

fortigate-config/
├── fortigate_config.txt   ← Generated CLI for FortiGate
└── fortigate_config.tpl   ← Template used for generation

🔐 Azure Authentication via GitHub Secrets

Before running your workflows, store your Azure Service Principal credentials in your repository’s Settings → Secrets → Actions:

Secret	Description
ARM_CLIENT_ID	Azure Service Principal Client ID
ARM_CLIENT_SECRET	Azure Service Principal Secret
ARM_SUBSCRIPTION_ID	Azure Subscription ID
ARM_TENANT_ID	Azure Tenant ID
🚀 How to Deploy
🧩 Option 1: Manual (Local CLI)
terraform init
terraform plan -var-file="fortigate_vars.tfvars"
terraform apply -var-file="fortigate_vars.tfvars"


After apply, you’ll find a generated file:

fortigate_config.txt


Paste its contents directly into your FortiGate CLI.

⚙️ Option 2: Automated (GitHub Actions)

Push your Terraform code to GitHub.

GitHub Actions automatically runs validation + plan.

Trigger the Terraform Apply workflow manually from the “Actions” tab.

Once complete, download your FortiGate config artifact.

🧱 Example Terraform Outputs
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

deployment_region = "centralus"
fortigate_cli_hint = "See templates/fortigate_config.tpl for generated CLI"
hub_public_ip_1 = "135.119.49.45"
hub_public_ip_2 = "172.202.45.135"
hub_resource_group = "hybridlab-hub-rg"
hub_vnet_name = "hybridlab-hub-vnet"

📡 Example Generated FortiGate Config
config vpn ipsec phase1-interface
  edit "azure-p1-tun1"
    set interface "wan1"
    set remote-gw 135.119.49.45
    set ike-version 2
    set keylife 28000
    set proposal AES256-SHA256
    set dhgrp DHGroup2
    set psksecret "HybridLab123!"
  next
end

config router bgp
  set as 65020
  config neighbor
    edit "169.254.21.1"
      set remote-as 65010
      set update-source "azure-tun1"
    next
  end
end

🧰 Prerequisites

Terraform ≥ 1.6.0

Azure CLI authenticated or Service Principal credentials

GitHub Actions enabled

FortiGate firewall reachable on the WAN interface

🧠 Best Practices

✅ Use remote backend for Terraform state:

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatelab001"
    container_name       = "terraformstate"
    key                  = "hybridlab.tfstate"
  }
}


✅ Keep .tfvars and .tfstate files out of Git (via .gitignore)
✅ Run plans in GitHub Actions, applies via approval
✅ Rotate shared keys and Azure SP secrets regularly

👨‍💻 Author

Jeremiah Eastwood
Network Engineer | Azure Hybrid | Fortinet SD-WAN | Infrastructure as Code

📍 Yukon, OK
📧 CISCONOMADIC@gmail.com

🔗 LinkedIn

💻 GitHub
