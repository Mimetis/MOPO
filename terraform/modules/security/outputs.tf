output keyvault_id {
    value = azurerm_key_vault.kv.id
}

output keyvault_name {
    value = azurerm_key_vault.kv.name
}

# This output is needed to properly wait for Key Vault policy assignment
output keyvault_policy_id {
    value = azurerm_key_vault_access_policy.kv.id
}
