variable "prefix" {
  description = "A prefix used for all resources in this example"
  type        = string
  default     = "mediawiki"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  type        = string
  default     = "eastus"
}

variable "env" {
  description = "Possible values could be Dev/Test/Prod."
  type        = string
  default     = "dev"
}

variable "aks_version" {
  description = "K8S  version"
  default     = "1.27.9"
}
