variable rg_name {
  description = "resource group name"
}

variable unique_string {
  description = "unique string added to all resource name"
}

variable environment {
  description = "Name of environment"
}

variable acr_prefix {
  default     = "acr"
  description = "User-defined prefix for local Azure Container Registry used by K8s cluster."
}

