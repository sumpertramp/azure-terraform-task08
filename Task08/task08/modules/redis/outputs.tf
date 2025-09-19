output "hostname_secret_name" { value = azurerm_key_vault_secret.hostname.name }
output "key_secret_name" { value = azurerm_key_vault_secret.primary_key.name }
output "hostname" { value = data.azurerm_redis_cache.this.hostname }

