// Parameters - these should be passed from the main deployment
@description('Azure region for resources')
param location string = 'eastus'

@description('Project name prefix')
param projectName string = 'myapp'

@description('Environment name')
param environment string = 'dev'

@description('Tags to apply to resources')
param tags object = {
  Environment: 'Development'
  Project: 'MyApp'
  Owner: 'DevTeam'
}

@description('Storage account SKU')
param storageSku string = 'Standard_LRS'

@description('Storage account kind')
param storageKind string = 'StorageV2'

@description('Minimum TLS version')
param minimumTlsVersion string = 'TLS1_2'

@description('Allow blob public access')
param allowBlobPublicAccess bool = false

@description('Network ACLs configuration')
param networkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Allow'
}

@description('List of containers to create')
param containers array = [
  {
    name: 'data'
    publicAccess: 'None'
  }
  {
    name: 'logs'
    publicAccess: 'None'
  }
  {
    name: 'uploads'
    publicAccess: 'Blob'
  }
]

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
    minimumTlsVersion: minimumTlsVersion
    allowBlobPublicAccess: allowBlobPublicAccess
    networkAcls: networkAcls
  }
  tags: tags
}

// Storage Containers
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