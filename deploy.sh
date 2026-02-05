#!/bin/bash

RESOURCE_GROUP="rg-appgw-test"
LOCATION="japaneast"
CERT_PASSWORD="P@ssw0rd123"

if [ ! -f appgw-cert.pfx ]; then
  echo "Certificate not found. Generating..."
  ./generate-cert.sh
fi

CERT_DATA=$(cat appgw-cert.pfx | base64 -w 0 2>/dev/null || cat appgw-cert.pfx | base64)

echo "Creating resource group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Deploying Application Gateway..."
DEPLOYMENT_NAME="appgw-$(date +%s)"
az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --name $DEPLOYMENT_NAME \
  --template-file appgw.bicep \
  --parameters certData="$CERT_DATA" certPassword="$CERT_PASSWORD"

echo "Deployment complete!"
echo "Getting Public IP..."
az deployment group show \
  --resource-group $RESOURCE_GROUP \
  --name $DEPLOYMENT_NAME \
  --query properties.outputs.publicIpAddress.value -o tsv
