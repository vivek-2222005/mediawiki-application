variable "prefix" {
  description = "A prefix used for all resources in this example"
  default     = "mediawiki"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default     = "eastus"
}

variable "env" {
  description = "Possible values could be Dev/Test/Prod."
  default     = "dev"
}

variable "aks_version" {
  description = "K8S  version"
  default     = "1.27.9"
}
