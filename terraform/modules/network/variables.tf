variable "rg_name" {}

variable environment {
    description = "Name of environment"
}

variable unique_string {}

variable "vnet_prefix" {
    default = "vnet"
    description = "Name of Azure virtual network. Only required for 'azure' network plugin"
}

variable "subnet_prefix" {
    default = "snet"
    description = "Name of Azure virtual network subnet. Only required for 'azure' network plugin"
}

variable "nsg_prefix" {
    default = "nsg"
    description = "User-defined Azure network security group"
}

variable "pod_inbound_prefix" {
    default = "akspods-in"
}

variable "pod_outbound_prefix" {
    default = "akspods-out"
}

