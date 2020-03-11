variable rg_name {
    description = "Resource group name"
}

variable unique_string {}

variable key_vault_name {
    description = "Key vault name"
}

variable acr_name {
    description = "ACR name"
}

variable subnet_name {
    description = "subnet name"
}

variable subnet_virtual_network_name {
    description = "subnet virtual network name"
}


variable environment {
    description = "Name of environment"
}

variable aks_sp_object_id {
    description = "Service principal object id used to execute the pipeline"
}


variable managed_identity_prefix {
    default     = "ami"
    description = "User-defined prefix of user managed identity."
}

