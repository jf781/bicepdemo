using './appServices/appServices.bicep'

param appServicePlanName = 'appServicePlanName'
param appServicePlanSkuName = 'P0v3'
param appServicePlanSkuTier = 'Premium0V3'
param appServicePlanKind = 'Linux'

param appInsights = {}

param webAppName = 'demoWebAppName'

param webAppSettings = []

param webAppSlots = [
  {
    name: 'staging'
    appSettings: [
      {
        name: 'ENVIRONMENT'
        value: 'staging'
      }
    ]
  }
]
