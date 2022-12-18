param location string = resourceGroup().location
param uniqueSeed string = '${resourceGroup().id}-${deployment().name}'  // example utob7veruf5g4

var tenantId = '31b21488-eb5e-4422-a181-1b15dd378dc8'
var serviceBusName = 'sb11-dev'
var keyvaultName = 'cakv-dev'
var spnObjectId = '474af495-7e5d-4841-a171-01a4ee85a5b4'

////////////////////////////////////////////////////////////////////////////////
// Infrastructure
////////////////////////////////////////////////////////////////////////////////

module keyvault 'modules/infra/keyvault.bicep' = {
  name: '${deployment().name}-infra-keyvault'
  params: {
    vaultName: keyvaultName
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
