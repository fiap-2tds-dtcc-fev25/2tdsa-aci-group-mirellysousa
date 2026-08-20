#!/usr/bin/env bash

set -Eeuo pipefail
set -x

export ACR_NAME=moneyhubrm566299
export ACR_SERVER=${ACR_NAME}.azurecr.io
export MYSQL_ROOT_PASSWORD=$(az keyvault secret show --vault-name kv-moneyhub-rm566299 --name mysql-root-password --query value --output tsv)
export MYSQL_DATABASE=db-dimdim
export MYSQL_USER=$(az keyvault secret show --vault-name kv-moneyhub-rm566299 --name mysql-user --query value --output tsv)
export MYSQL_PASSWORD=$(az keyvault secret show --vault-name kv-moneyhub-rm566299 --name mysql-password --query value --output tsv)
export SPRING_DATASOURCE_URL=$(az keyvault secret show --vault-name kv-moneyhub-rm566299 --name spring-datasource-url --query value --output tsv)
export SPRING_DATASOURCE_USER=$MYSQL_USERNAME
export SPRING_DATASOURCE_PASSWORD=$MYSQL_PASSWORD
export CONNECTIONSTRINGS=$(az keyvault secret show --vault-name kv-moneyhub-rm566299 --name connection-strings --query value --output tsv)

export ADMIN_USERNAME=$(az acr credential show --name ${ACR_NAME} \
                                        --resource-group rg-money-hub \
                                        --query username --output tsv) && \
export ADMIN_PASSWORD=$(az acr credential show --name ${ACR_NAME} \
                                        --resource-group rg-money-hub \
                                        --query passwords[0].value --output tsv)

az container create \
    --resource-group rg-money-hub \
    --file aci-deploy.yaml