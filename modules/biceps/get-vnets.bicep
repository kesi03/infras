@description('Gets existing virtual networks in the subscription')
resource virtualNetworks 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  scope: resourceGroup()
}

output virtualNetworks array = virtualNetworks.name