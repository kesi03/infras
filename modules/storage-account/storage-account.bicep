// Load variables from JSON file
@description('Path to variables JSON file')
param variablesFile string = 'storage-variables.json'

var variables = json(loadTextContent(variablesFile))

// Parameters loaded from variables file
param location string = variables.location
param projectName string = variables.projectName
param environment string = variables.environment
param tags object = variables.tags
param storageSku string = variables.storage.sku
param storageKind string = variables.storage.kind

// Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: '${projectName}-${environment}-rg'
  location: location
  tags: tags
}

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: '${projectName}${environment}stg'
  location: location
  resourceGroup: rg.name
  sku: {
    name: storageSku
  }
  kind: storageKind
  properties: {
    minimumTlsVersion: variables.storage.minimumTlsVersion
    allowBlobPublicAccess: variables.storage.allowBlobPublicAccess
    networkAcls: variables.storage.networkAcls
  }
  tags: tags
}

// Storage Containers
@description('List of containers to create')
param containers array = variables.containers

resource containers 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = [for container in containers: {
  parent: storageAccount
  name: container.name
  properties: {
    publicAccess: container.publicAccess
  }
}]

// Outputs
output resourceGroupName string = rg.name
output storageAccountName string = storageAccount.name
output storageAccountId string = storageAccount.id
output storageAccountEndpoints object = storageAccount.properties.primaryEndpoints