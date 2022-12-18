// user assigned managed identity
param uminame string = 'umi-app'

// create user assigned managed identity
resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: uminame
  location: resourceGroup().location
}
