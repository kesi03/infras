@description('Name of the virtual network')
param vnetName string

@description('Gets existing subnets in the specified virtual network')
resource subnets 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = [for subnet in range(0, 50): {
  name: '${vnetName}/subnet-${subnet}'
  scope: resourceGroup()
}]

output subnets array = [for subnet in subnets: {
  name: split(subnet.name, '/')[1]
  addressPrefix: subnet.properties.addressPrefix
}]