@description('Gets all resource groups in the subscription')
resource resourceGroups 'Microsoft.Resources/resourceGroups@2023-07-01' existing = {
  scope: subscription()
}

output resourceGroups array = [for rg in resourceGroups: {
  name: rg.name
  location: rg.location
  tags: rg.tags
}]