provider "azurerm" {
  version = "=2.0.0"
  features {}
}

# terraform {
#     backend "azurerm" { }
# }

resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.rg_prefix}-${var.environment}"
  location = var.rg_location
  tags = {
    environment = var.environment
  }
}

data "azurerm_client_config" "current" {}

module "network" {
  source = "./modules/network"

  rg_name       = azurerm_resource_group.rg.name
  unique_string = random_string.unique.result
  environment   = var.environment
}

module "security" {
  source = "./modules/security"

  rg_name       = azurerm_resource_group.rg.name
  unique_string = random_string.unique.result
  environment   = var.environment
  kv_prefix     = "akv"
}

module "acr" {
  source = "./modules/acr"

  rg_name       = azurerm_resource_group.rg.name
  unique_string = random_string.unique.result
  environment   = var.environment
  acr_prefix    = "acr"
}


module "identity" {
  source = "./modules/identity"

  unique_string               = random_string.unique.result
  rg_name                     = azurerm_resource_group.rg.name
  acr_name                    = module.acr.acr_name
  key_vault_name              = module.security.keyvault_name
  subnet_name                 = module.network.snet_name
  subnet_virtual_network_name = module.network.snet_virtual_network_name

  aks_sp_object_id = var.aks_sp_object_id
  environment      = var.environment

  managed_identity_prefix = "ami"
}


module "cluster" {
  source = "./modules/cluster"

  rg_name       = azurerm_resource_group.rg.name
  unique_string = random_string.unique.result
  environment   = var.environment

  aks_sp_client_id     = var.aks_sp_client_id
  aks_sp_client_secret = var.aks_sp_client_secret

  pod_vnet_subnet_id = module.network.snet_id
}



# resource "azurerm_role_assignment" "podid_kv_role" {
#     scope                = module.security.keyvault_id
#     role_definition_name = "Reader"
#     principal_id         = module.cluster.pod_mi_principal_id
# }

# resource "azurerm_key_vault_access_policy" "podid" {
#     key_vault_id       = module.security.keyvault_id
#     tenant_id          = data.azurerm_client_config.current.tenant_id
#     object_id          = module.cluster.pod_mi_principal_id
#     secret_permissions = ["get"]
# }

# resource "azurerm_servicebus_namespace" "sbns" {
#     name                = "${var.sbns_prefix}-${var.environment}-${random_string.unique.result}"
#     location            = azurerm_resource_group.rg.location
#     resource_group_name = azurerm_resource_group.rg.name
#     sku                 = "Standard"
# }

# resource "azurerm_key_vault_secret" "sbns" {
#     name         = var.sbns_prefix
#     value        = azurerm_servicebus_namespace.sbns.default_primary_connection_string
#     key_vault_id = module.security.keyvault_id

#     # This dependency is needed to properly wait for Key Vault policy assignment
#     depends_on   = [module.security.keyvault_policy_id]
# }
