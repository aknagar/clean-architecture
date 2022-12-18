@description('The Azure Key Vault name.')
param keyVaultName string
param tenantId string
param objectId string

resource keyvaultReadPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: '${keyVaultName}/add'
  properties: {
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: objectId       
        permissions: {
          certificates: [
            'get'
            'list'
          ]
          keys: [
            'get'
            'list'
          ]
          secrets: [
            'get'
            'list'
          ]
        }        
      }
    ]
  }
}
