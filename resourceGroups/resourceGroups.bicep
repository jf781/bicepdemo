targetScope = 'subscription'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Tags of the resource.')
param rg object = {}

param unusedParam string = 'unused'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' =  {
  name: rg.name
  location: rg.location
  tags: tags
}

@description('Name of the resource group')
output name string = resourceGroup.name

@description('Name of the resource group')
output location string = resourceGroup.location

@description('Resource group tags')
output tags object = resourceGroup.tags
