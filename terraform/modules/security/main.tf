data "azurerm_resource_group" "rg" {
    name = var.rg_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
    name                = "${var.kv_prefix}-${var.environment}-${var.unique_string}"
    location            = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
    tenant_id           = data.azurerm_client_config.current.tenant_id
    sku_name            = "standard"

    network_acls {
        default_action = "Allow"
        bypass         = "AzureServices"
    }
}

resource "azurerm_key_vault_access_policy" "kv" {
    key_vault_id       = azurerm_key_vault.kv.id
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    secret_permissions = [
        "get",
        "set",
        "delete",
        "list"
    ]
    certificate_permissions = [
        "get",
        "create",
        "delete",
        "list"
    ]
}

resource "azurerm_key_vault_secret" "example" {
  name         = "MySecret"
  value        = "I am a drummer."
  key_vault_id = azurerm_key_vault.kv.id
}