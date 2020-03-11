
output assigned_identity_id {
    value = azurerm_user_assigned_identity.podid.id
}

output assigned_identity_client_id {
    value = azurerm_user_assigned_identity.podid.client_id
}

output assigned_identity_name {
    value = azurerm_user_assigned_identity.podid.name
}

output assigned_identity_principal_id {
    value = azurerm_user_assigned_identity.podid.principal_id
}
