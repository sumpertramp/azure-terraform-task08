variable "name" {
  type        = string
  description = "Azure Kubernetes Service (AKS) küme adı (örn. cmtr-vf06h1cc-mod8-aks)."
}

variable "location" {
  type        = string
  description = "AKS kümesinin oluşturulacağı Azure bölgesi (örn. eastus)."
}

variable "resource_group_name" {
  type        = string
  description = "AKS ve ilişkili kaynakların yer alacağı Resource Group adı."
}

variable "tags" {
  type        = map(string)
  description = "Bu modülün oluşturduğu tüm kaynaklara uygulanacak ortak etiketler (örn. { Creator = \"sumeyye_unal@epam.com\" })."
}

variable "node_count" {
  type        = number
  description = "Varsayılan (system) node havuzundaki düğüm sayısı (örn. 1)."
}

variable "node_size"  {
  type        = string
  description = "Varsayılan (system) node havuzundaki VM boyutu (örn. Standard_D2ads_v5)."
}

variable "os_disk_type" {
  type        = string
  description = "Node havuzu OS disk tipi. Geçerli değerler: \"Ephemeral\" veya \"Managed\". (Görev için: \"Ephemeral\")."
}

variable "acr_id"  {
  type        = string
  description = "Azure Container Registry (ACR) kaynağının Resource ID'si. AKS kubelet kimliğine AcrPull rolü atamak için kullanılır."
}

variable "kv_id"   {
  type        = string
  description = "Azure Key Vault kaynağının Resource ID'si. AKS kubelet kimliğine KV 'secret' erişimi tanımlamak için kullanılır."
}
