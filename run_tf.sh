#!/bin/bash

cd "$(dirname "$0")"/terraform

echo "Current working directory: $PWD"

echo "-----------------------------------------------"
echo "Applying terraform IAC"
echo "-----------------------------------------------"

terraform init

terraform apply -var 'aks_sp_client_id=9480c305-6138-444e-ad6f-0f3b01b28bab' \
                -var 'aks_sp_object_id=c4f8f130-bde7-4102-94b4-9823afbe4ffd' \
                -var 'aks_sp_client_secret=767803de-e667-44db-aefa-0372c2ba47d7' \
                -var 'rg_prefix=rg_bopo4'

echo "$(terraform output -json)" > ../.output.json