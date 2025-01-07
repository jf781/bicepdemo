// Parameters
@description('Location for all resources.')
param location string

@description('Tags to apply to resources.')
param tags object = {}

@description('Name of the App Insights resource.')
param appInsightsName string

@description('Name of the Log Analytics workspace.')
param logAnalyticWorkspace object

// Resource definitions
resource appInsights 'microsoft.insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: existingLAWorkspace.id
  }
}

// Reference resouces
resource existingLAWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  scope: resourceGroup(logAnalyticWorkspace.subId, logAnalyticWorkspace.rgName)
  name: logAnalyticWorkspace.workspaceName
}


// Outputs
output appInsightsKey string = appInsights.properties.InstrumentationKey
output connectionString string = appInsights.properties.ConnectionString
output logAnalyticsWorkspaceId string = existingLAWorkspace.id
