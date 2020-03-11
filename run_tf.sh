#!/bin/bash

cd "$(dirname "$0")"/terraform

echo "Current working directory: $PWD"

echo "-----------------------------------------------"
echo "terraform init"
echo "-----------------------------------------------"

terraform init


echo "-----------------------------------------------"
echo "Write .tfvars file"
echo "-----------------------------------------------"

echo 'aks_sp_client_id="9480c305-6138-444e-ad6f-0f3b01b28bab"
aks_sp_object_id="c4f8f130-bde7-4102-94b4-9823afbe4ffd"
aks_sp_client_secret="767803de-e667-44db-aefa-0372c2ba47d7"
rg_prefix="rg_mopo1"
' > terraform.tfvars

echo "-----------------------------------------------"
echo "terraform plan"
echo "-----------------------------------------------"
terraform plan -out='plan_mopo.tfplan'

echo "-----------------------------------------------"
echo "terraform apply"
echo "-----------------------------------------------"
terraform apply "plan_mopo.tfplan"


echo "-----------------------------------------------"
echo "terraform output"
echo "-----------------------------------------------"
echo "$(terraform output -json)" > ../.output.json