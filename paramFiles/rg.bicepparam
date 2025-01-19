
using '../resourceGroups/resourceGroups.bicep'

param rg = {
  name: 'demoRg'
  location: 'eastus2'
}

param tags = {
  environment: 'dev'
}

