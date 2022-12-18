@description('The Azure Key Vault name.')
param keyVaultName string
param secretName string
@secure()
param secretValue string

// Get reference to KV
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
}

// Store the connectionstrings in Keyvault
resource storageAccountConnectionStrings 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: secretName
  parent: keyVault
  properties: {
    value: secretValue
  }
}
