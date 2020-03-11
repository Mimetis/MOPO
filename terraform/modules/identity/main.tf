## Get the current config
data "azurerm_client_config" "current" {

}
## Get the resource group information
data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

## Get the key vault information
data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

## Get the key vault information
data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

## Get the subnet information
data "azurerm_subnet" "snet" {
    name                 = var.subnet_name
    virtual_network_name = var.subnet_virtual_network_name
    resource_group_name  = data.azurerm_resource_group.rg.name  
}

## Create the assigned identity
resource "azurerm_user_assigned_identity" "podid" {
  name                = "${var.managed_identity_prefix}-${var.environment}-${var.unique_string}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

## Assign reader role to managed identity on resource group
## using here the managed identity "Principal ID"
resource "azurerm_role_assignment" "rg_reader" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.podid.principal_id
}

## Assign reader role to managed identity on azure key vault
## using here the managed identity "Principal ID"
# resource "azurerm_role_assignment" "kv_reader" {
#   scope                = data.azurerm_key_vault.kv.id
#   role_definition_name = "Reader"
#   principal_id         = azurerm_user_assigned_identity.podid.principal_id
# }

# Assign Managed Identity Operator to service principal for accessing managed identity
# using here the service principal "object id"
resource "azurerm_role_assignment" "mi_operator" {
  scope                = azurerm_user_assigned_identity.podid.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_sp_object_id
}

# Assign AcrPull authorization to service principal
# using here the service principal "object id"
resource "azurerm_role_assignment" "acr_role" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_sp_object_id
}


# Assign Network Contributor authorization to service principal
# using here the service principal "object id"
resource "azurerm_role_assignment" "snet_role" {
    scope                = data.azurerm_subnet.snet.id
    role_definition_name = "Network Contributor"
    principal_id         = var.aks_sp_object_id
}


# Assign the right on keyvault to managed identity
## using here the managed identity "principal id"
resource "azurerm_key_vault_access_policy" "managed_identity" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.podid.principal_id

  key_permissions = ["get", "list"]
  secret_permissions = [ "get", "set", "list"]
  certificate_permissions = [ "get", "list"]
  
}
