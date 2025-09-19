terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = ">=3.113.0" }
  }
}

resource "azurerm_key_vault" "kv" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  enable_rbac_authorization  = false
  tags                       = var.tags
}

resource "azurerm_key_vault_access_policy" "user_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id    = var.current_user_object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge", "Recover", "Backup", "Restore"
  ]
}


