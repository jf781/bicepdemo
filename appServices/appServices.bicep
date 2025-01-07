
// Parameters - general
@description('Location for all resources.')
param location string = resourceGroup().location

@description('Tags to apply to resources.')
param tags object = {}

@description('Name of the Web App.')
param webAppName string

@description('App settings for the main Web App.')
param webAppSettings array

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

@description('List of deployment slots to create. Each object includes "name" and an array of "appSettings" for that slot.')
param webAppSlots array

@description('Applicaiton Insights instance information.')
param appInsights object

param unusedVar string


// Variables
var webAppAppInsightsSettings = [
  {
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    value: appInsights.appInsightsKey
  }
  {
    name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
    value: appInsights.connectionString
  }
]

var allWebAppSettings = union(webAppAppInsightsSettings, webAppSettings)
// var allWebAppSettings = webAppSettings

module appServiceModule '../modules/appServiceModule/v1.0.0/main.bicep' = {
  name: 'appServiceModule'
  params: {
    location: location
    tags: tags
    appServicePlanName: appServicePlanName
    appServicePlanSkuName: appServicePlanSkuName
    appServicePlanKind: appServicePlanKind
    appServicePlanSkuTier: appServicePlanSkuTier
    appServicePlanReserved: appServicePlanReserved
    webAppName: webAppName
    webAppSettings: allWebAppSettings
    webAppSlots: webAppSlots
  }
}
