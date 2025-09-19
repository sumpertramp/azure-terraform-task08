variable "name_prefix" {
  type        = string
  default     = "cmtr-vf06h1cc-mod8"
  description = "Prefix used for naming all resources in this task to ensure consistent and unique naming."
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region where all resources will be deployed."
}

variable "tags" {
  type        = map(string)
  default     = { Creator = "sumeyye_unal@epam.com" }
  description = "A map of common tags applied to all resources (e.g., Creator, environment)."
}

variable "acr_sku" {
  type        = string
  default     = "Basic"
  description = "The SKU (pricing tier) for Azure Container Registry (e.g., Basic, Standard, Premium)."
}

variable "git_repo_url" {
  type        = string
  description = "The URL of the GitHub repository containing the application code and Dockerfile (e.g., https://github.com/<user>/<repo>.git)."
}

variable "git_branch" {
  type        = string
  default     = "main"
  description = "The Git branch to use for building the Docker image via ACR Task."
}

variable "git_pat" {
  type        = string
  sensitive   = true
  description = "A GitHub Personal Access Token (PAT) used by ACR Task to access the repository."
}

