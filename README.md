# Azure-Web-Application-Infrastructure-Bicep

This repository contains Bicep templates for deploying an Azure web application infrastructure. The templates include resources for App Services, Monitoring, Key Vault, SQL Server, and App Configuration.

## Prerequisites

- Azure CLI
- jq (for parsing JSON in shell scripts)

## Deployment Steps

### 1. Set Azure Subscription

Set the Azure subscription where you want to deploy the resources:

```bash
az account set -s "Your Subscription Name"
```

### 2. Deploy App config, App service plan, sql, etc...
```bash
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file main.bicep \
  --parameters dev.bicepparam
```

### 3. Deploy App service, deploy slots, etc... pointing to app config settings
```bash
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file main.bicep \
```

## Folder Structure and Deployed Resources

### resourceGroups

This folder contains the Bicep template for creating the resource group.

- `resourceGroups.bicep`: Defines the resource group with specified tags and location.

### coreResources

This folder contains the Bicep templates for deploying core resources.

- `core.bicep`: Deploys Key Vault, SQL Server, and App Configuration with necessary parameters and settings.

### appServices

This folder contains the Bicep templates for deploying app services.

- `appServices.bicep`: Deploys the App Service Plan, Web App, and deployment slots with specified settings.

### modules/appServiceModule

This folder contains the Bicep module for app services.

- `main.bicep`: Handles the creation of the App Service Plan and Web App, including app settings and deployment slots.

### modules/monitoringModule

This folder contains the Bicep module for monitoring.

- `main.bicep`: Deploys Application Insights and Log Analytics workspace for monitoring purposes.

## Next steps
1. Incorporate workflow into pipeline
2. Monitor and manage the deployed resources