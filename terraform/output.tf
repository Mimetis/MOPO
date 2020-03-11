
output subscription_id {
    value = data.azurerm_client_config.current.subscription_id
}
output tenant_id {
    value = data.azurerm_client_config.current.tenant_id
}
output rg_name {
    value = azurerm_resource_group.rg.name
}
output aks_cluster_name {
    value = module.cluster.aks_cluster_name
}
output keyvault_name {
    value = module.security.keyvault_name
}

output assigned_identity_id {
    value = module.identity.assigned_identity_id
}

output assigned_identity_name {
    value = module.identity.assigned_identity_name
}

output assigned_identity_client_id {
    value = module.identity.assigned_identity_client_id
}

