param location string = resourceGroup().location
param uniqueSeed string = '${resourceGroup().id}-${deployment().name}'  // example utob7veruf5g4

////////////////////////////////////////////////////////////////////////////////
// Infrastructure
////////////////////////////////////////////////////////////////////////////////

var serviceBusName = 'sb11-dev'
module keyvault 'modules/infra/keyvault.bicep' = {
  name: '${deployment().name}-infra-keyvault'
  params: {
    vaultName: 'cakv-dev'
    location: location
    
  }
}

module serviceBus 'modules/infra/servicebus.bicep' = {
  name: '${deployment().name}-infra-servicebus'
  params: {
    name: serviceBusName
    location: location
  }
}

module containerAppsEnvironment 'modules/infra/container-apps-env.bicep' = {
  name: '${deployment().name}-infra-container-app-env'
  params: {
    location: location
    uniqueSeed: uniqueSeed
  }
}

////////////////////////////////////////////////////////////////////////////////
// Container apps
////////////////////////////////////////////////////////////////////////////////

var queueName = 'orders'
var serviceBusQueueName = '${serviceBusName}/${queueName}'
var policyName = 'testsaspolicy'
resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2022-01-01-preview' existing = {
  name: serviceBusQueueName  
}

var containerAppsEnvName = 'containerappenv-utob7veruf5g4'
resource containerAppsEnv 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: containerAppsEnvName
}
module webApi 'modules/apps/web-api.bicep' = {
  name: '${deployment().name}-app-web-api'
  dependsOn: [
    containerAppsEnv
    serviceBusQueue
  ]
  params: {
    location: location
    containerAppsEnvironmentId: containerAppsEnv.id    
    containerAppsEnvironmentDomain: containerAppsEnv.properties.defaultDomain
    serviceBusConnectionString: 'Endpoint=sb://${serviceBusName}.servicebus.windows.net/;SharedAccessKeyName=${policyName};SharedAccessKey=${listKeys('${serviceBusQueue.id}/AuthorizationRules/${policyName}', serviceBusQueue.apiVersion).primaryKey}' 
  }
}

module queueWorker 'modules/apps/queue-worker.bicep' = {
  name: '${deployment().name}-queue-worker'
  dependsOn: [
    containerAppsEnv
    serviceBusQueue
  ]
  params: {
    location: location
    containerAppsEnvironmentId: containerAppsEnv.id    
    containerAppsEnvironmentDomain: containerAppsEnv.properties.defaultDomain
    serviceBusConnectionString: 'Endpoint=sb://${serviceBusName}.servicebus.windows.net/;SharedAccessKeyName=${policyName};SharedAccessKey=${listKeys('${serviceBusQueue.id}/AuthorizationRules/${policyName}', serviceBusQueue.apiVersion).primaryKey};EntityPath=${queueName}' 
  }
}
