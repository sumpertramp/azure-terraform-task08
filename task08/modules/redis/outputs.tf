output "hostname" { value = azurerm_redis_cache.this.hostname }
output "primary_key" {
  value     = azurerm_redis_cache.this.primary_access_key
  sensitive = true
}