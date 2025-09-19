variable "name" {
  type        = string
  description = "The name of the Azure Redis Cache instance."
}

variable "location" {
  type        = string
  description = "Azure region where the Redis Cache will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Redis Cache will be created."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the Redis Cache resource."
}

variable "key_vault_id" {
  type        = string
  description = "The resource ID of the Key Vault where Redis secrets will be stored."
}

variable "key_vault_name" {
  type        = string
  description = "The name of the Key Vault where Redis secrets will be stored."
}

variable "redis_hostname_secret_name" {
  type        = string
  description = "The name of the Key Vault secret that will store the Redis hostname."
}

variable "redis_key_secret_name" {
  type        = string
  description = "The name of the Key Vault secret that will store the Redis primary access key."
}
