variable "name" {
  type        = string
  description = "AKS kümesi için temel ad kökü. İlgili adlandırmalarda kullanılacak."
}

variable "resource_group_name" {
  type        = string
  description = "AKS ve ilişkili kaynakların oluşturulacağı mevcut Azure Resource Group adı."
}

variable "location" {
  type        = string
  description = "Kaynakların dağıtılacağı Azure bölgesi (ör. eastus, westeurope)."
}

variable "node_size" {
  type        = string
  description = "Node havuzu için VM boyutu (ör. Standard_DS2_v2, Standard_B4ms)."
}

variable "node_count" {
  type        = number
  description = "Varsayılan (system) node havuzundaki node sayısı (en az 1 önerilir)."
}

variable "nodepool_name" {
  type        = string
  description = "Varsayılan node havuzu adı (ör. system, np1). Sadece küçük harf, rakam ve kısa çizgi kullanılması önerilir."
}

variable "os_disk_type" {
  type        = string
  description = "Node'ların OS disk tipi (ör. Managed veya Ephemeral; bölge ve VM tipine göre destek değişebilir)."
}

variable "acr_id" {
  type        = string
  description = "Kümeye imaj çekme yetkisi vermek için Azure Container Registry'nin tam kaynak kimliği (resource ID)."
}

variable "keyvault_id" {
  type        = string
  description = "Gizli anahtarlar/sertifikalar için kullanılacak Azure Key Vault'un tam kaynak kimliği (resource ID)."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Azure kaynaklarına uygulanacak etiketler (anahtar/değer)."
}
