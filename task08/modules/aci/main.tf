resource "azurerm_container_group" "this" {
  name = var.name
  location = var.location
  resource_group_name = var.resource_group_name
  os_type = "Linux"
  ip_address_type = "Public"
  dns_name_label = var.dns_name_label
  restart_policy = "Always"
  tags = var.tags


  image_registry_credential {
    server = var.registry_server
    username = var.registry_username
    password = var.registry_password
  }


  container {
    name = var.name
    image = var.image
    cpu = 1
    memory = 1.5


    ports { port = 8080 }


    environment_variables = var.env
    secure_environment_variables = var.secure_env
  }
}

