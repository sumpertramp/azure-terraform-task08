#############################
# modules/acr/main.tf
#############################

# Bu modül içinde sadece modül input'larını kullan.
# Alias birleştirmeyi (effective_*) root locals.tf'de yapıp buraya geçiriyoruz.

locals {
  # Repo URL boşsa source_trigger hiç oluşturmayalım (placeholder ve 404'leri önler)
  create_source_trigger = length(trimspace(var.repo_url_with_deploy_token)) > 0
}

resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = true
  tags                = var.tags
}

# Build the image from repo root path "task08/application" using ACR Tasks
resource "azurerm_container_registry_task" "build" {
  name                  = "${var.name}-task"
  container_registry_id = azurerm_container_registry.this.id
  is_system_task        = false

  platform {
    os           = "Linux"
    architecture = "amd64"
  }

  docker_step {
    context_path         = "task08/application"
    context_access_token = var.git_pat # <-- sadece modül değişkeni
    dockerfile_path      = "task08/application/Dockerfile"
    image_names          = ["${var.image_name}:latest"]
    cache_enabled        = true
  }

  # Repo URL boşsa hiç trigger yaratma (plan/apply sırasında 404'i engeller)
  dynamic "source_trigger" {
    for_each = local.create_source_trigger ? [1] : []
    content {
      name           = "gittrigger"
      events         = ["commit"]
      source_type    = "Github"
      repository_url = var.repo_url_with_deploy_token # <-- sadece modül değişkeni
      branch         = "main"
      authentication {
        token_type = "PAT"
        token      = var.git_pat # <-- sadece modül değişkeni
      }
    }
  }

  # Doğrulama ACR'de bir zamanlayıcı bekliyor
  timer_trigger {
    name     = "nightly"
    schedule = "0 2 * * *"
    enabled  = true
  }
}

# Apply anında bir defa tetikle (doğrulama istiyor)
resource "azurerm_container_registry_task_schedule_run_now" "run_now" {
  container_registry_task_id = azurerm_container_registry_task.build.id
}
