variable rg_prefix {
    default = "rg_bopo4"
    description = "The prefix of the Azure resource group in which AKS cluster will be deployed."
}

variable rg_location {
    default = "northeurope"
    description = "The name of the Azure region where AKS cluster will be deployed."
}

variable environment {
    description = "Name of environment (dev/test/prod).  Value set by Azure DevOps.  Specify on commandline when running 'terraform apply' locally"
    default = "dev"    
}

variable aks_sp_client_id {
    description = "Client/App ID of AAD service principal used by AKS service to create K8s cluster.  Actual value stored in 'TF_VAR_aks_sp_client_id environment' variable"
    default = "9480c305-6138-444e-ad6f-0f3b01b28bab"
}
variable aks_sp_object_id {
    description = "Object ID of AAD service principal used by Azure Keyvault.  Actual value stored in 'TF_VAR_aks_sp_object_id' environment variable"
    default = "c4f8f130-bde7-4102-94b4-9823afbe4ffd"
}

variable aks_sp_client_secret {
    description = "Client/App ID secret (password) of AAD service principal.  Actual value stored in 'TF_VAR_aks_sp_client_secret' environment variable"
    default = "767803de-e667-44db-aefa-0372c2ba47d7"
}

variable sbns_prefix {
    default = "sb"
    description = "User-defined prefix of service bus namespace."
}
