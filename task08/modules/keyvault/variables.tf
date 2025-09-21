variable "name" {
  type        = string
  description = "Kaynak(lar) için temel ad kökü. İlgili tüm isimlendirmelerde kullanılacak."
}

variable "resource_group_name" {
  type        = string
  description = "Kaynakların oluşturulacağı mevcut Azure Resource Group'un adı."
}

variable "location" {
  type        = string
  description = "Kaynakların dağıtılacağı Azure bölgesi (ör. eastus, westeurope)."
}

variable "sku" {
  type        = string
  description = "Hizmetin SKU/Fiyatlandırma katmanı (ör. Basic/Standard/Premium veya hizmete özgü değerler)."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Azure kaynaklarına uygulanacak etiketler (anahtar/değer)."
}



