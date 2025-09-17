resource "azurerm_redis_cache" "redis" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 2
  family              = "C"
  sku_name            = "Basic"
  minimum_tls_version = "1.2"
  tags                = var.tags
}

# Redis erişim bilgilerini KV'ye yaz
resource "azurerm_key_vault_secret" "redis_hostname" {
  name         = "redis-hostname"
  value        = azurerm_redis_cache.redis.hostname
  key_vault_id = var.kv_id
}

resource "azurerm_key_vault_secret" "redis_primary_key" {
  name         = "redis-primary-key"
  value        = azurerm_redis_cache.redis.primary_access_key
  key_vault_id = var.kv_id
}
