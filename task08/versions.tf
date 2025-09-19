terraform {
  required_version = ">= 1.5.7"
  required_providers {
    azurerm    = { source = "hashicorp/azurerm", version = ">=3.113.0" }
    kubectl    = { source = "alekc/kubectl", version = ">=2.0.4" }
    kubernetes = { source = "hashicorp/kubernetes", version = ">= 2.29.0" }
  }
}

provider "azurerm" {
  features {}
}
