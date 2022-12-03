param location string = resourceGroup().location
param uniqueSeed string = '${resourceGroup().id}-${deployment().name}'  // example utob7veruf5g4

////////////////////////////////////////////////////////////////////////////////
// Infrastructure
////////////////////////////////////////////////////////////////////////////////

module keyvault 'infra/keyvault.bicep' = {
  name: '${deployment().name}-infra-keyvault'
  params: {
    vaultName: 'cakv-dev'
    location: location
    
  }
}

module serviceBus 'infra/servicebus.bicep' = {
  name: '${deployment().name}-infra-servicebus'
  params: {
    name: 'sb11-dev'
    location: location
  }
}

module containerAppsEnvironment 'infra/container-apps-env.bicep' = {
  name: '${deployment().name}-infra-container-app-env'
  params: {
    location: location
    uniqueSeed: uniqueSeed
  }
}

////////////////////////////////////////////////////////////////////////////////
// Container apps
////////////////////////////////////////////////////////////////////////////////

module webApi 'modules/apps/web-api.bicep' = {
  name: '${deployment().name}-app-web-api'
  dependsOn: [
    containerAppsEnvironment
  ]
  params: {
    location: location
    //serviceBusConnectionString: 'Endpoint=sb://${serviceBusRef.name}.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=${listKeys('${serviceBusRef.id}/AuthorizationRules/RootManageSharedAccessKey', serviceBusRef.apiVersion).primaryKey}'
    //serviceBusConnectionString: 'Endpoint=sb://xyz.servicebus.windows.net/'
    containerAppsEnvironmentId: containerAppsEnvironment.outputs.containerAppsEnvironmentId    
    containerAppsEnvironmentDomain: containerAppsEnvironment.outputs.containerAppsEnvironmentDomain
  }
}
