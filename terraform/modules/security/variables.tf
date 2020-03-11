variable rg_name {}

variable unique_string {}

variable kv_prefix {
    default = "kv"
    description = "User-defined prefix for Azure keyvault used by K8s cluster."
}

variable environment {
    description = "Name of environment"
}
