terraform {
  required_version = ">= 1.5.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }
  }
}

# Nested bloklar tek satırda olamaz — çok satıra alınmalı:
provider "azurerm" {
  features {}
}

# kubernetes ve kubectl provider'ları AKS çıktılarından main.tf içinde
# dinamik olarak yapılandırılıyor, burada ekstra ayar yok.
