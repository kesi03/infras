// Load variables from JSON file
@description('Path to variables JSON file')
param variablesFile string = 'variables.json'

var variables = json(loadTextContent(variablesFile))

// Parameters loaded from variables file
param location string = variables.location
param projectName string = variables.projectName
param environment string = variables.environment
param tags object = variables.tags

// Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: '${projectName}-${environment}-rg'
  location: location
  tags: tags
}

// Storage Account
resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: '${projectName}${environment}stg'
  location: location
  resourceGroup: rg.name
  sku: {
    name: variables.storage.sku
  }
  kind: 'StorageV2'
  tags: tags
}

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: '${projectName}-${environment}-vnet'
  location: location
  resourceGroup: rg.name
  properties: {
    addressSpace: {
      addressPrefixes: [
        variables.vnet.addressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: variables.subnets.default.addressPrefix
        }
      }
    ]
  }
  tags: tags
}

// Outputs
output resourceGroupName string = rg.name
output storageAccountName string = storage.name
output virtualNetworkName string = vnet.name