terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  backend "remote" {
    organization = "eastwood-tech-lab"

    workspaces {
      name = "azure-fortigate-hybrid"
    }
  }
}

provider "azurerm" {
  features {}
}
