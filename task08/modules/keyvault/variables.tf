variable "name" {
  type        = string
  description = "The name of the resource to create (e.g., Key Vault, Redis, ACR, etc.)."
}

variable "location" {
  type        = string
  description = "Azure region where the resource will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resource."
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID associated with the subscription."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the resource (e.g., Creator, environment)."
}

variable "current_user_object_id" {
  type        = string
  description = "The Azure AD object ID of the current user, used for access policies."
}


