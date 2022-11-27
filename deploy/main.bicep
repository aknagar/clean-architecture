// param location string = resourceGroup().location
// param uniqueSeed string = '${resourceGroup().id}-${deployment().name}'

param appname string = 'testapp'
param environment string = 'staging'
param region string = 'eastus'
param resourceGroup string = 'caRG'

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

module serviceBus 'infra/servicebus.bicep' = {
  name: '${deployment().name}-infra-servicebus'
  params: {
    name: 'sb11-dev'
    location: 'eastus'
  }
}
