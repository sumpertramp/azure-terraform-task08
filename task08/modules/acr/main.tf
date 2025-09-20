resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = true
  tags                = var.tags
}

# ✔ ACR Task (doğru şema)
resource "azurerm_container_registry_task" "build" {
  name                  = "${var.name}-task"
  container_registry_id = azurerm_container_registry.acr.id

  platform {
    os = "Linux"
  }

  docker_step {
    dockerfile_path      = "application/Dockerfile" # context'e göre relative
    image_names          = ["${var.image_name}:latest"]
    context_path         = "${var.git_repo_url}#${var.git_branch}:task08" # branch + alt klasör
    context_access_token = var.git_pat
  }

  timer_trigger {
    name     = "daily-build"
    schedule = "0 3 * * *"
    enabled  = true
  }
}


resource "azurerm_container_registry_task_schedule_run_now" "run_now" {
  container_registry_task_id = azurerm_container_registry_task.build.id
  depends_on                 = [azurerm_container_registry_task.build]
}

