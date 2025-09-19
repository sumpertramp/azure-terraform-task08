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
  agent_pool_name       = "Default"

  # platform bir BLOK olmalı
  platform {
    os = "Linux"
  }

  # Git tetikleyici alanları artık source_trigger BLOĞU içinde düz alanlar
  source_trigger {
    name           = "gitTrigger"
    events         = ["commit"]
    repository_url = var.git_repo_url
    source_type    = "Github"
    branch         = var.git_branch
  }

  # Docker adımı: context olarak repo URL + PAT
  docker_step {
    dockerfile_path      = "task08/application/Dockerfile"
    image_names          = ["${var.image_name}:latest"]
    context_path         = var.git_repo_url
    context_access_token = var.git_pat
  }

  # ⏰ Ayrı bir *resource* yerine burada timer_trigger bloğu kullanılır
  timer_trigger {
    name     = "daily-build"
    schedule = "0 3 * * *" # her gün 03:00 UTC
    enabled  = true
  }
}

resource "azurerm_container_registry_task_schedule_run_now" "run_now" {
  container_registry_task_id = azurerm_container_registry_task.build.id
  depends_on                 = [azurerm_container_registry_task.build]
}

