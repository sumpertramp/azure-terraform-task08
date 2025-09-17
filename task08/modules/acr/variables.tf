variable "name" {
  type        = string
  description = "Azure Container Registry (ACR) adı (örn. cmtrvf06h1ccmod8cr)."
}

variable "location" {
  type        = string
  description = "ACR'nin oluşturulacağı Azure bölgesi (örn. eastus)."
}

variable "resource_group_name" {
  type        = string
  description = "ACR ve ilişkili kaynakların yer alacağı Resource Group adı."
}

variable "sku" {
  type        = string
  description = "ACR SKU seviyesi: Basic, Standard veya Premium."
}

variable "tags" {
  type        = map(string)
  description = "Oluşturulan kaynaklara uygulanacak ortak etiketler (örn. { Creator = \"sumeyye_unal@epam.com\" })."
}

variable "git_repo_url" {
  type        = string
  description = "Docker imajının kaynak kodunun bulunduğu Git deposunun HTTPS URL'i (örn. https://github.com/<kullanici>/<repo>.git)."
}

variable "git_branch" {
  type        = string
  description = "ACR Task tarafından build edilecek branch adı (örn. main)."
}

variable "git_pat" {
  type        = string
  sensitive   = true
  description = "Kaynak Git deposuna erişim için kullanılan Personal Access Token (ACR Task 'context_access_token' ve source trigger kimlik doğrulaması için)."
}

variable "dockerfile_path" {
  type        = string
  description = "Repo köküne göre Dockerfile yolu (örn. application/Dockerfile)."
}

variable "image_name" {
  type        = string
  description = "ACR içinde üretilecek imaj adı/repoya ismi (örn. cmtr-vf06h1cc-mod8-app)."
}
