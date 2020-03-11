#!/bin/bash
echo "-----------------------------------------------"
echo "Run helm scripts"
echo "-----------------------------------------------"

cd "$(dirname "$0")"/charts

echo "Current working directory: $PWD"


echo "-----------------------------------------------"
echo "Get terraform output"
echo "-----------------------------------------------"

OUTPUT=$(jq . ../.output.json)
CLUSTER_NAME=$(echo $OUTPUT | jq -r '.aks_cluster_name.value')
KEYVAULT_NAME=$(echo $OUTPUT | jq -r '.keyvault_name.value')
RG_NAME=$(echo $OUTPUT | jq -r '.rg_name.value')
SUBSCRIPTION_ID=$(echo $OUTPUT | jq -r '.subscription_id.value')
TENANT_ID=$(echo $OUTPUT | jq -r '.tenant_id.value')
CLUSTER_NAME=$(echo $OUTPUT | jq -r '.aks_cluster_name.value')
ASSIGNED_IDENTITY_ID=$(echo $OUTPUT | jq -r '.assigned_identity_id.value')
ASSIGNED_IDENTITY_NAME=$(echo $OUTPUT | jq -r '.assigned_identity_name.value')
ASSIGNED_IDENTITY_CLIENT_ID=$(echo $OUTPUT | jq -r '.assigned_identity_client_id.value')

echo "CLUSTER_NAME: $CLUSTER_NAME"
echo "KEYVAULT_NAME: $KEYVAULT_NAME"
echo "RG_NAME: $RG_NAME"
echo "SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo "TENANT_ID: $TENANT_ID"
echo "CLUSTER_NAME: $CLUSTER_NAME"
echo "ASSIGNED_IDENTITY_ID: $ASSIGNED_IDENTITY_ID"
echo "ASSIGNED_IDENTITY_NAME: $ASSIGNED_IDENTITY_NAME"
echo "ASSIGNED_IDENTITY_CLIENT_ID: $ASSIGNED_IDENTITY_CLIENT_ID"

az aks get-credentials -g $RG_NAME -n $CLUSTER_NAME --overwrite-existing

helm install ingress ./ingress
helm install flexvol ./flexvol
helm install pod-identity ./pod-identity \
        --set managedIdentity.id=$ASSIGNED_IDENTITY_ID \
        --set managedIdentity.clientId=$ASSIGNED_IDENTITY_CLIENT_ID \
        --set managedIdentity.name=$ASSIGNED_IDENTITY_NAME
helm install helloworld ./helloworld \
        --set keyVault.name=$KEYVAULT_NAME \
        --set subscription.id=$SUBSCRIPTION_ID \
        --set subscription.resourceGroup=$RG_NAME \
        --set subscription.tenantId=$TENANT_ID

