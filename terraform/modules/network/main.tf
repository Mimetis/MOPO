data "azurerm_resource_group" "rg" {
    name = var.rg_name
}

resource "azurerm_virtual_network" "vnet" {
    name                = "${var.vnet_prefix}-${var.environment}-${var.unique_string}"
    location            = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "snet" {
    name                 = "${var.subnet_prefix}-${var.environment}-${var.unique_string}"
    resource_group_name  = data.azurerm_resource_group.rg.name  
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix       = "10.0.0.0/22" 
}

resource "azurerm_network_security_group" "nsg" {
    name                = "${var.nsg_prefix}-${var.environment}-${var.unique_string}"
    location            = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
    subnet_id                 = azurerm_subnet.snet.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "pod_inbound" {
    name                        = "${var.pod_inbound_prefix}-${var.environment}-${var.unique_string}"
    resource_group_name         = data.azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    access                      = "Allow"
    priority                    = 1000
    direction                   = "Inbound"
}

resource "azurerm_network_security_rule" "pod_outbound" {
    name                        = "${var.pod_outbound_prefix}-${var.environment}-${var.unique_string}"
    resource_group_name         = data.azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    access                      = "Allow"
    priority                    = 1001
    direction                   = "Outbound"
}
