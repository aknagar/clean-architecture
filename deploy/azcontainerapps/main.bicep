param location string = resourceGroup().location

var spnObjectId = '474af495-7e5d-4841-a171-01a4ee85a5b4'
var serviceBusName = 'sb-dev-11'
var keyvaultName = 'cakv-dev-11'
var containerAppsEnvironmentName = 'containerappenv-dev-11'

var tenantId = subscription().tenantId

////////////////////////////////////////////////////////////////////////////////
// Container apps
////////////////////////////////////////////////////////////////////////////////

var queueName = 'orders'
var serviceBusQueueName = '${serviceBusName}/${queueName}'
var policyName = 'testsaspolicy'
resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2022-01-01-preview' existing = {
  name: serviceBusQueueName  
}

resource containerAppsEnv 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: containerAppsEnvironmentName
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

////////////////////////////////////////////////////////////////////////////////
// Access control
////////////////////////////////////////////////////////////////////////////////
module addKeyVaultPolicy 'modules/access-control/keyvault-policy-add.module.bicep' = {
  name: 'addKeyVaultPolicy'
  params: {
    keyVaultName: keyvaultName
    tenantId: tenantId
    objectId: spnObjectId
  }
}
