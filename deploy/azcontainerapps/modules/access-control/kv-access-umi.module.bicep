@description('The Azure Key Vault name.')
param keyVaultName string
param appName string
param umiName string

// Get reference to KV
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
}

resource umi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: umiName
}

// create role assignment
var KEY_VAULT_SECRETS_USER_ROLE_GUID = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')

resource keyVaultMiUser 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('SecretsUser', appName)
  scope: keyVault
  properties: {
    principalId: umi.properties.principalId
    roleDefinitionId: KEY_VAULT_SECRETS_USER_ROLE_GUID
  }
}
