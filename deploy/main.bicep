// param location string = resourceGroup().location
// param uniqueSeed string = '${resourceGroup().id}-${deployment().name}'

////////////////////////////////////////////////////////////////////////////////
// Infrastructure
////////////////////////////////////////////////////////////////////////////////

module keyvault 'infra/keyvault.bicep' = {
  name: '${deployment().name}-infra-keyvault'
  params: {
    vaultName: 'cakv-dev'
    location: 'eastus'
  }
}
