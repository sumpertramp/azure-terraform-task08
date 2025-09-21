resource "azurerm_container_registry" "this" {
  name = var.name
  resource_group_name = var.resource_group_name
  location = var.location
  sku = var.sku
  admin_enabled = true
  tags = var.tags
}


# Build the image from repo root path "task08/application" using ACR Tasks
resource "azurerm_container_registry_task" "build" {
  name                  = "${var.name}-task"
  container_registry_id = azurerm_container_registry.this.id
  is_system_task        = true
  log_template          = "{{.Run.ID}}"

  platform {
    os           = "Linux"
    architecture = "amd64"
  }

  # Docker step: repo içindeki konteks klasörü + erişim token'ı
  docker_step {
    context_path         = "task08/application"
    context_access_token = var.git_pat
    dockerfile_path      = "task08/application/Dockerfile"
    image_names          = ["${var.image_name}:latest"]
    cache_enabled        = true
  }

  # Kaynaktan otomatik tetikleme (commit)
  source_trigger {
    name           = "gittrigger"
    events         = ["commit"]

    # V3 provider şemasına göre bu alanlar doğrudan burada:
    source_type    = "Github"                                 # <-- blok değil alan
    repository_url = var.repo_url_with_deploy_token
    branch         = "main"

    authentication {
      token_type = "PAT"
      token      = var.git_pat
    }
  }

  # Ayrı bir 'task_schedule' kaynağı YOK; timer trigger burada tanımlanır:
  timer_trigger {
    name     = "nightly"
    schedule = "0 2 * * *"   # 02:00 UTC
    enabled  = true
  }
}
