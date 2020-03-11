variable rg_name {}

variable unique_string {}

variable environment {
    description = "Name of environment"
}

variable aks_sp_client_id {}

variable aks_sp_client_secret {}

variable pod_vnet_subnet_id {}

variable aks_cluster_prefix {
    default     = "aks"
    description = "User-defined prefix of Kubernetes cluster to be created by AKS."
}

variable aks_agent_count {
    default     = 3
    description = "Number of worker nodes in AKS cluster."
}

variable aks_vm_size {
    default = "Standard_DS2_v2"
    description = "AKS cluster VM size.  Use Azure VM SKU notation."
}

variable aks_availability_zones {
    default = [1, 2, 3]
    description = "Number of availability zones for AKS nodes"
}

variable "aks_max_pods" {
    default = "110"
    description = "Maximum number of pods per AKS node."
}

variable aks_dns_prefix {
    default     = "aks-maink8s"
    description = "User-defined prefix to be used by Kubernetes for cluster internal DNS services."
}

variable aks_admin_username {
    default     = "aksadmin"
    description = "Name of Kubernetes cluster administrator."
}

variable "aks_network_plugin" {
    default     = "azure"
    description = "Name of AKS network plugin.  Must be one of 'Kubenet' or 'Azure'."
}

variable "aks_service_cidr" {
    default = "10.2.0.0/23"
    description = "User-defined K8s services address range (in CIDR format).  Changing this value implies the cluster must be recreated"
}

variable "aks_dns_service_ip" {
    default = "10.2.0.10"
    description = "User-defined address for K8s DNS service.  Must be in 'aks_service_cidr' range.  Changing this value implies the cluster must be recreated"
}

variable "aks_docker_bridge_cidr" {
    default = "172.17.0.1/16"
    description = "User-defined network range (in CIDR format).  Must be specified for 'azure' network plugin.  Changing this value implies the cluster must be recreated"
}

variable la_workspace_prefix {
    default     = "ala"
    description = "User-defined prefix for Azure Log Analytics workspace."
}

# variable ingress_namespace {
#     default     = "ingress"
#     description = "Name of the ingress namespace"
# }

# variable certmanager_crd_install_url {
#     default     = "https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml"
#     description = "URL to certmanager Custom Resource Definition"
# }
