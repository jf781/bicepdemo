@description('Location for all resources.')
param location string = resourceGroup().location

@description('Tags to apply to resources.')
param tags object = {}


// App Service Plan
@description('Name of the App Service Plan.')
param appServicePlanName string

@description('App Service Plan SKU name, for example: F1, B1, B2, P1V2, etc.')
param appServicePlanSkuName string

@description('App Service Plan kind, for example: Windows, Linux, etc.')
param appServicePlanKind string

@description('App Service Plan SKU tier, for example: Free, Basic, PremiumV2, etc.')
param appServicePlanSkuTier string

@description('App Service Plan Reservation.')
param appServicePlanReserved bool = false

@description('Applicaiton Insights instance information.')
param appInsights object

@description('App settings for the main Web App.')
param webAppSettings array


// Web App
@description('Name of the Web App.')
param webAppName string

// Deployment Slots
@description('List of deployment slots to create. Each object includes "name" and an array of "appSettings" for that slot.')
param webAppSlots array 

// Saved as a potential option for parsing through the webAppSettings array
// var updatedwebAppSettings = [
//   for (key, i) in webAppSettings: {
//     name: webAppSettings[i].name
//     value: webAppSettings[i].value
//   }
// ]

// var allWebAppSettings = union(webAppAppInsightsSettings, updatedwebAppSettings)

// Variables
var webAppAppInsightsSettings = [
  {
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    value: appInsights.appInsightsKey.value
  }
  {
    name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
    value: appInsights.connectionString.value
  }
]

var allWebAppSettings = union(webAppAppInsightsSettings, webAppSettings)



// Resource definitions
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: appServicePlanSkuName
    tier: appServicePlanSkuTier
  }
  kind: appServicePlanKind
  properties: {
    reserved: appServicePlanReserved
  }
}



resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        for appSettings in allWebAppSettings: {
          name: appSettings.name
          value: appSettings.value
        }
      ]
    }
  }
}

resource webAppSlotsRes 'Microsoft.Web/sites/slots@2022-09-01' = [for slot in webAppSlots: {
  parent: webApp
  name: slot.name
  location: location
  tags: tags
  properties: {
    siteConfig: {
      appSettings: [ for setting in slot.appSettings: {
          name: setting.name
          value: setting.value
        }
      ]
    }
  }
}]
