data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

## Should we creae a log analytics module ?
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.la_workspace_prefix}-${var.environment}-${var.unique_string}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "main" {
  solution_name         = "ContainerInsights"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

## Generate a SSH key
resource "tls_private_key" "k8s" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

## Save the private key in the local workspace ##
resource "null_resource" "save-key" {

  triggers = {
    key = tls_private_key.k8s.private_key_pem
  }

  provisioner "local-exec" {
    command = <<EOF
      mkdir -p ${path.module}/.ssh
      echo "${tls_private_key.k8s.private_key_pem}" > ${path.module}/.ssh/id_rsa
      chmod 0600 ${path.module}/.ssh/id_rsa
EOF
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.aks_cluster_prefix}-${var.environment}-${var.unique_string}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  default_node_pool {
    name               = "default"
    node_count         = var.aks_agent_count
    vm_size            = var.aks_vm_size
    availability_zones = var.aks_availability_zones
    max_pods           = var.aks_max_pods
    vnet_subnet_id     = var.pod_vnet_subnet_id
  }

  dns_prefix = "${var.aks_dns_prefix}-${var.unique_string}"

  service_principal {
    client_id     = var.aks_sp_client_id
    client_secret = var.aks_sp_client_secret
  }

  linux_profile {
    admin_username = var.aks_admin_username

    ssh_key {
      key_data = "${trimspace(tls_private_key.k8s.public_key_openssh)} ${var.aks_admin_username}@azure.com"
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
    }
  }

  network_profile {
    network_plugin     = var.aks_network_plugin
    service_cidr       = var.aks_service_cidr
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
  }

  role_based_access_control {
    enabled = true
  }
}
