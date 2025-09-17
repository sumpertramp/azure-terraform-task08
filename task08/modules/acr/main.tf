resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = true
  tags                = var.tags
}

resource "azurerm_container_registry_task" "build_task" {
  name                  = "${var.name}-build"
  container_registry_id = azurerm_container_registry.acr.id

  platform {
    os           = "Linux"
    architecture = "amd64"
  }

  # Kaynak repo'dan build
  docker_step {
    dockerfile_path       = var.dockerfile_path           # örn: application/Dockerfile
    context_path          = var.git_repo_url              # HTTPS repo URL
    context_access_token  = var.git_pat
    image_names           = ["${var.image_name}:{{.Run.ID}}", "${var.image_name}:latest"]
  }

  # Otomatik tetikleyici (GitHub/Azure Repos'tan)
  source_trigger {
    name           = "src"
    source_type    = "Github"            # Azure Repos ise: "VisualStudioTeamService"
    repository_url = var.git_repo_url
    branch         = var.git_branch
    events         = ["commit"]          # veya ["commit","pullrequest"]
    enabled        = true

    authentication {
      token      = var.git_pat
      token_type = "PAT"                 # PAT kullandığımız için zorunlu
    }
  }
}

# Periyodik çalıştırma (cron)
resource "azurerm_container_registry_task_schedule_run" "sched" {
  container_registry_task_id = azurerm_container_registry_task.build_task.id
  schedule                   = "*/15 * * * *"
}
