variable "name" {
  type        = string
  description = "The name of the Azure Container Instance (ACI)."
}

variable "location" {
  type        = string
  description = "Azure region where the ACI will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the ACI will be created."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the ACI resource."
}

variable "dns_name_label" {
  type        = string
  description = "The DNS name label used to create a publicly accessible FQDN for the ACI."
}

variable "image" {
  type        = string
  description = "The full path to the container image in Azure Container Registry (ACR) (e.g., <acr_login_server>/<image_name>:latest)."
}

variable "registry_server" {
  type        = string
  description = "The login server URL of the Azure Container Registry (ACR) where the image is stored."
}

variable "registry_username" {
  type        = string
  description = "The admin username used to authenticate to the Azure Container Registry (ACR)."
}

variable "registry_password" {
  type        = string
  description = "The admin password used to authenticate to the Azure Container Registry (ACR)."
}

variable "redis_hostname" {
  type        = string
  description = "The Redis Cache hostname, typically stored in Azure Key Vault and injected as a secure environment variable."
}

variable "redis_password" {
  type        = string
  description = "The Redis Cache primary access key, typically stored in Azure Key Vault and injected as a secure environment variable."
}
