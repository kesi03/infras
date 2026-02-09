targetScope = 'subscription'

@description('Path to variables JSON file')
param variablesFile string = 'modules/storage-account/storage-variables.json'

var variables = json(loadTextContent(variablesFile))

module storageAccount 'modules/storage-account/storage-account.bicep' = {
  name: 'storageAccountDeployment'
  params: {
    location: variables.location
    projectName: variables.projectName
    environment: variables.environment
    tags: variables.tags
    storageSku: variables.storage.sku
    storageKind: variables.storage.kind
    minimumTlsVersion: variables.storage.minimumTlsVersion
    allowBlobPublicAccess: variables.storage.allowBlobPublicAccess
    networkAcls: variables.storage.networkAcls
    containers: variables.containers
  }
}

output storageAccountName string = storageAccount.outputs.storageAccountName
output resourceGroupName string = storageAccount.outputs.resourceGroupName