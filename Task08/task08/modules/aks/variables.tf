variable "name" {
  type        = string
  description = "The name of the Azure Kubernetes Service (AKS) cluster."
}

variable "location" {
  type        = string
  description = "Azure region where the AKS cluster will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the AKS cluster will be created."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the AKS resource."
}

variable "acr_id" {
  type        = string
  description = "The resource ID of the Azure Container Registry (ACR) that the AKS cluster should be allowed to pull images from."
}

variable "key_vault_id" {
  type        = string
  description = "The resource ID of the Azure Key Vault where AKS will access secrets via the CSI driver."
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID used for configuring Key Vault access policies for AKS."
}

variable "node_count" {
  type        = number
  description = "The number of nodes in the default AKS node pool."
}

variable "node_size" {
  type        = string
  description = "The size (VM SKU) of each node in the AKS default node pool (e.g., Standard_D2ads_v5)."
}

variable "node_pool_name" {
  type        = string
  description = "The name of the default AKS node pool (e.g., system)."
}
