variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "name_prefix" {
  description = "Common name prefix/pattern"
  type        = string
  default     = "cmtr-vf06h1cc-mod8"
}

variable "acr_sku" {
  description = "ACR SKU (Basic/Standard/Premium)"
  type        = string
  default     = "Basic"
}

variable "git_repo_url" {
  description = "Git repository URL to build from (HTTPS)"
  type        = string
}

variable "git_branch" {
  description = "Git branch to build"
  type        = string
  default     = "main"
}

variable "git_pat" {
  description = "Sensitive Git personal access token for ACR Task context_access_token"
  type        = string
  sensitive   = true
}

variable "tags" {
  type = map(string)
  default = {
    Creator = "sumeyye_unal@epam.com"
  }
}
