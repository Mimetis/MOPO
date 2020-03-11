data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

## Create acr
## the symbol "-" is not supported in the name, so delete it
resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_prefix}${var.environment}${var.unique_string}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Premium"
}

