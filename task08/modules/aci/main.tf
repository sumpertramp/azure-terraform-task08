resource "azurerm_container_group" "aci" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = replace(var.name, "_", "-")   # DNS label
  tags                = var.tags

  image_registry_credential {
    server   = var.acr_server
    username = var.acr_username
    password = var.acr_password
  }

  container {
    name   = "app"
    image  = var.image
    cpu    = var.cpu
    memory = var.memory_gb

    ports {
      port     = 5000
      protocol = "TCP"
    }

    environment_variables = {
      CREATOR       = "ACI"
      REDIS_PORT    = "6380"
      REDIS_SSL_MODE= "True"
    }

    secure_environment_variables = {
      REDIS_URL = var.redis_hostname
      REDIS_PWD = var.redis_primary_key
    }
  }
}
