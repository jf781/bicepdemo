using '../resources/resources.bicep'

param appInsightsName = 'appInsightsName'

param logAnalyticWorkspace = {
  subId: '8b503f66-26cb-4c32-b0a6-fe5a08f137ca'
  rgName: 'automationhub'
  workspaceName: 'AH-LAW01'
}

param keyVaultAdminGroupId = '15030c68-3278-4d9c-885c-1ceabd690d70'

param webAppName = 'jfBicepDemoWebApp'

param appConfigPublicNetworkAccess = 'Enabled'

param appConfigSkuName = 'Standard'

param appSvcAppConfigKeys = [
  {
    name: 'key1:subkey1'
    value: 'value1'
    label: ''
  }
  {
    name: 'key2:subkey2'
    value: 'value2'
    label: 'Production'
  }
  {
    name: 'key3:subkey3'
    value: 'value3'
    label: 'Production'
  }
]

param appServicePlanName = 'appServicePlanName'

param appServicePlanSkuName = 'P0v3'

param appServicePlanSkuTier = 'Premium0V3'

param appServicePlanKind = 'Linux'

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
