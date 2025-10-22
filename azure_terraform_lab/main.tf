terraform {
  required_version = ">= 1.6.0"

  backend "remote" {
    organization = "Eastwood-Technologies"

    workspaces {
      name = "Azure-IPsec-VPN-with-Virtual-NetwortKGateway"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}
