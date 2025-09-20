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

  # Webhook gerektiren source_trigger YOK

  docker_step {
    # Context'i repo içindeki "task08" ALT KLASÖRÜNE sabitliyoruz
    # ve branch'i açık seçik belirtiyoruz.
    context_path = "${var.git_repo_url}#${var.git_branch}:task08"
    # Dockerfile path, context'e göre relatif olmalı:
    dockerfile_path = "application/Dockerfile"

    image_names = ["${var.image_name}:latest"]

    # Özel repo ise PAT gerekli (scope: repo)
    context_access_token = var.git_pat
  }

  # İsteğe bağlı günlük tetikleyici (webhook değil)
  timer_trigger {
    name     = "daily-build"
    schedule = "0 3 * * *"
    enabled  = true
  }
}

# Apply anında bir kere koşturup doğrulamada 'succeeded run' getirmek için:
resource "azurerm_container_registry_task_schedule_run_now" "run_now" {
  container_registry_task_id = azurerm_container_registry_task.build.id
  depends_on                 = [azurerm_container_registry_task.build]
}

