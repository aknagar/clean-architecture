param location string = resourceGroup().location
param uniqueSeed string = '${resourceGroup().id}-${deployment().name}'  // example utob7veruf5g4

////////////////////////////////////////////////////////////////////////////////
// Infrastructure
////////////////////////////////////////////////////////////////////////////////

var serviceBusName = 'sb11-dev'
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
    name: serviceBusName
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

var queueName = '${serviceBusName}/orders'
resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2022-01-01-preview' existing = {
  name: queueName
}

var containerAppsEnvName = '${deployment().name}-infra-container-app-env'
resource containerAppsEnv 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: containerAppsEnvName
}
module webApi 'modules/apps/web-api.bicep' = {
  name: '${deployment().name}-app-web-api'
  dependsOn: [
    containerAppsEnvironment
    serviceBusQueue
  ]
  params: {
    location: location
    containerAppsEnvironmentId: containerAppsEnv.id    
    containerAppsEnvironmentDomain: containerAppsEnv.properties.defaultDomain
    serviceBusConnectionString: 'Endpoint=sb://${serviceBusQueue.name}.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=${listKeys('${serviceBusQueue.id}/AuthorizationRules/RootManageSharedAccessKey', serviceBusQueue.apiVersion).primaryKey}' 
  }
}
