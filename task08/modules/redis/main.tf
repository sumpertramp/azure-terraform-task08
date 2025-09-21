resource "azurerm_redis_cache" "this" {
  name = var.name
  location = var.location
  resource_group_name = var.resource_group_name
  capacity = var.capacity
  family = var.family
  sku_name = var.sku_name
  non_ssl_port_enabled = false
  minimum_tls_version = "1.2"
  tags = var.tags
}


# Store hostname and primary key into Key Vault
resource "azurerm_key_vault_secret" "hostname" {
  name = var.redis_hostname_secret_name
  value = azurerm_redis_cache.this.hostname
  key_vault_id = var.kv_id
}


resource "azurerm_key_vault_secret" "primary_key" {
  name = var.redis_primarykey_secret_name
  value = azurerm_redis_cache.this.primary_access_key
  key_vault_id = var.kv_id
}

