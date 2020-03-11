az identity create -g rgaks2-dev -n podid-dev -o json
{
    "clientId": "14e3d8ff-e947-42b8-acc1-c1ede45cefc8",
    "clientSecretUrl": "https://control-northeurope.identity.azure.net/subscriptions/6d854ccd-e85d-4a3e-baee-af4f95a56211/resourcegroups/rgaks2-dev/providers/Microsoft.ManagedIdentity/userAssignedIdentities/podid-dev/credentials?tid=72f988bf-86f1-41af-91ab-2d7cd011db47&oid=5cf1aa4c-67b0-4756-915a-1f9f643f7c52&aid=14e3d8ff-e947-42b8-acc1-c1ede45cefc8",
    "id": "/subscriptions/6d854ccd-e85d-4a3e-baee-af4f95a56211/resourcegroups/rgaks2-dev/providers/Microsoft.ManagedIdentity/userAssignedIdentities/podid-dev",
    "location": "northeurope",
    "name": "podid-dev",
    "principalId": "5cf1aa4c-67b0-4756-915a-1f9f643f7c52",
    "resourceGroup": "rgaks2-dev",
    "tags": {},
    "tenantId": "72f988bf-86f1-41af-91ab-2d7cd011db47",
    "type": "Microsoft.ManagedIdentity/userAssignedIdentities"
  }


# Assign reader role to managed identity on resource group
az role assignment create --role Reader 
    --assignee 5cf1aa4c-67b0-4756-915a-1f9f643f7c52 # mi.principalId
    --scope /subscriptions/6d854ccd-e85d-4a3e-baee-af4f95a56211/resourcegroups/rgaks2-dev # rg.name

# Assign reader role to managed identity on azure key vault ? OPTIONAL ??
az role assignment create --role Reader 
    --assignee 5cf1aa4c-67b0-4756-915a-1f9f643f7c52 
    --scope /subscriptions/6d854ccd-e85d-4a3e-baee-af4f95a56211/resourceGroups/rgaks2-dev/providers/Microsoft.KeyVault/vaults/kv-dev-rwq0ug

# Get service principal clientId
az aks show -g rgaks2-dev -n aks-main8ks-dev --query servicePrincipalProfile.clientId -o tsv
9480c305-6138-444e-ad6f-0f3b01b28bab

# Assign Managed Identity Operator to service principal for accessing managed identity
az role assignment create   
  --role "Managed Identity Operator" 
  --assignee 9480c305-6138-444e-ad6f-0f3b01b28bab 
  --scope /subscriptions/6d854ccd-e85d-4a3e-baee-af4f95a56211/resourcegroups/rgaks2-dev/providers/Microsoft.ManagedIdentity/userAssignedIdentities/podid-dev

# Create policy for accessing [get] certificate / secret / key in keyvault for managed identity 
az keyvault set-policy -n kv-dev-rwq0ug --certificate-permissions get --spn 14e3d8ff-e947-42b8-acc1-c1ede45cefc8
az keyvault set-policy -n kv-dev-rwq0ug --secret-permissions get --spn 14e3d8ff-e947-42b8-acc1-c1ede45cefc8
az keyvault set-policy -n kv-dev-rwq0ug --key-permissions get --spn 14e3d8ff-e947-42b8-acc1-c1ede45cefc8