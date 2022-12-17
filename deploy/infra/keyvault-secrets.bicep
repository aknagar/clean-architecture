param storageAccountNames array

param keyVaultName string

// Create storage accounts
resource storageAccounts 'Microsoft.Storage/storageAccounts@2019-06-01' existing = [ for name in storageAccountNames :{
  name: name
}]

// Get reference to KV
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
}

// Store the connectionstrings in KV if specified
resource storageAccountConnectionStrings 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = [ for (name, i) in storageAccountNames :{
  name: '${keyVault.name}/${name}-connectionstring'
  properties: {
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccounts[i].name};AccountKey=${listKeys(storageAccounts[i].id, storageAccounts[i].apiVersion).keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
  }
}]
