/*
Notes to be added here to talk about the who what why of this file

1. User who runs the command will need to be a member of the group specified in the paramter `keyVaultAdminGroupId`

*/

// Parameters - general
@description('Location for all resources.')
param location string = resourceGroup().location

@description('Tags to apply to resources.')
param tags object = {}

@description('Random GUID for used for creating SQL KV password.')
@secure()
param randomGuid1 string = newGuid()

@secure()
param randomGuid2 string = newGuid()

// Parameters - monitoringModule
@description('Name of the App Insights resource.')
param appInsightsName string

@description('Name of the Log Analytics workspace.')
param logAnalyticWorkspace object


// Parameters - appServiceModule
@description('Name of the Web App.')
param webAppName string


// Parameters - appSvcKeyVault
@description('Enable deployment to the key vault.')
param keyVaultDeployment bool = true

@description('Enable key vault to be used for disk encryption.')
param keyVaultDisk bool = true

@description('Enable key vault to be used for template deployment.')
param keyVaultTemplateDeployment bool = true

@description('Enable purge protection for the key vault.')
param keyVaultPur bool = true

@description('Enable RBAC authorization for the key vault.')
param keyVaultRbacAuthorization bool = true

@description('SKU family of the key vault.')
param keyVaultSkuFamily string = 'A'

@description('SKU name of the key vault.')
param keyVaultSkuName string = 'standard'

@description('Object ID of group to assign key vault admin access to.')
param keyVaultAdminGroupId string

@description('Key Vault RBAC ID. Defaults to the built-in "Key Vault Administrator" role.')
param keyVaultAdminRbacId string = '/providers/Microsoft.Authorization/roleDefinitions/00482a5a-887f-4fb3-b363-3b7fe8e74483'

// Paramters - App Configuration
@description('Enable App Configuration public access.')
param appConfigPublicNetworkAccess string

@description('App Configuration SKU name.')
param appConfigSkuName string = 'Standard'

@description('List of key-value pairs to add to the App Configuration.')
param appSvcAppConfigKeys array = []

// Parameters - SQL Server
@description('Public network access for the SQL Server.')
param sqlPublicNetworkAccess string = 'Disabled'

@description('Minimum TLS version for the SQL Server.')
param sqlMinimumTlsVersion string = '1.2'



// Variables
var randomString1 = substring(randomGuid1, 0, 8)
var randomString2 = substring(randomGuid2, 0, 8)
var sqlAdminPassword = '${randomString1}!${randomString2}'



// Managed resources
module monitoringModule '../modules/monitoringModule/v1.0.0/main.bicep' = {
  name: 'monitoringModule'
  params: {
    location: location
    tags: tags
    appInsightsName: appInsightsName
    logAnalyticWorkspace: logAnalyticWorkspace
  }
}

resource appSvcKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: '${webAppName}-kv'
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    enabledForDeployment: keyVaultDeployment
    enabledForDiskEncryption: keyVaultDisk
    enabledForTemplateDeployment: keyVaultTemplateDeployment
    enablePurgeProtection: keyVaultPur
    enableRbacAuthorization: keyVaultRbacAuthorization
    sku: {
      family: keyVaultSkuFamily
      name: keyVaultSkuName
    }
  }
}

resource appSvcKeyVaultRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: appSvcKeyVault
  name: guid(resourceGroup().id, keyVaultAdminGroupId, appSvcKeyVault.id)
  properties: {
    principalId: keyVaultAdminGroupId
    roleDefinitionId: keyVaultAdminRbacId
  }
}

resource appSvcSqlServerAdminPassword 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: appSvcKeyVault
  name: '${webAppName}-sql-admin-password'
  properties: {
    value: sqlAdminPassword
  }
}

resource appSvcSqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: '${webAppName}-sql'
  location: location
  tags: tags
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: sqlAdminPassword
    publicNetworkAccess: sqlPublicNetworkAccess
    minimalTlsVersion: sqlMinimumTlsVersion

  }
}

resource appSvcAppConfig 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: '${webAppName}-appconfig'
  location: location
  tags: tags
  properties: {
    publicNetworkAccess: appConfigPublicNetworkAccess
  }
  sku: {
    name: appConfigSkuName
  }
}

resource appSvcAppConfigKeyValues 'Microsoft.AppConfiguration/configurationStores/keyValues@2023-03-01' = [for key in appSvcAppConfigKeys: {
  parent: appSvcAppConfig
  name: '${key.name}$${key.label}'
  properties: {
    value: key.value
  }
}]

output appInsightsKey string = monitoringModule.outputs.appInsightsKey
output appInsightsConnectionString string = monitoringModule.outputs.connectionString

output appConfigKeyValues array = [
  for (key, i) in appSvcAppConfigKeys: {
    name: appSvcAppConfigKeyValues[i].name
    value: appSvcAppConfigKeyValues[i].properties.value
  }
]


