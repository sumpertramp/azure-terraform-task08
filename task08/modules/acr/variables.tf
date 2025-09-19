variable "name" {
  type        = string
  description = "The name of the Azure Container Registry (ACR). Must be globally unique."
}

variable "location" {
  type        = string
  description = "Azure region where the ACR will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the ACR will be created."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the ACR resource."
}

variable "sku" {
  type        = string
  description = "The SKU (pricing tier) of the ACR, e.g., Basic, Standard, or Premium."
}

variable "git_repo_url" {
  type        = string
  description = "The URL of the GitHub repository containing the Dockerfile and application source (e.g., https://github.com/<user>/<repo>.git)."
}

variable "git_branch" {
  type        = string
  default     = "main"
  description = "The Git branch to use when building the Docker image."
}

variable "git_pat" {
  type        = string
  sensitive   = true
  description = "A GitHub Personal Access Token (PAT) used for accessing the repository and triggering ACR Tasks."
}

variable "image_name" {
  type        = string
  description = "The name of the Docker image to be built and stored in ACR (e.g., cmtr-vf06h1cc-mod8-app)."
}

