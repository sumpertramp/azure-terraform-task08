variable "name" {
  type        = string
  description = "Azure Redis Cache instance name (e.g., cmtr-vf06h1cc-mod8-redis)."
}

variable "location" {
  type        = string
  description = "Azure region where the Redis instance will be deployed (e.g., eastus)."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group that will contain the Redis and related resources."
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to all resources created by this module (e.g., { Creator = \"sumeyye_unal@epam.com\" })."
}

variable "kv_id" {
  type        = string
  description = "Resource ID of the Key Vault where Redis connection details (hostname, primary key) will be stored as secrets."
}

variable "kv_uri" {
  type        = string
  description = "Vault URI of the Key Vault (e.g., https://cmtr-vf06h1cc-mod8-kv.vault.azure.net/)."
}

