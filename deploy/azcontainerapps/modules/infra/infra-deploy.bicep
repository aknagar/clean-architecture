param location string = resourceGroup().location
// param uniqueSeed string = '${resourceGroup().id}-${deployment().name}'  // example utob7veruf5g4

var serviceBusName = 'sb-dev-11'
var keyvaultName = 'cakv-dev-11'
var containerAppsEnvironmentName = 'containerappenv-dev-11'
var logAnalyticsWorkspaceName = 'loganalytics-dev-11'

////////////////////////////////////////////////////////////////////////////////
// Infrastructure
////////////////////////////////////////////////////////////////////////////////

module keyvault 'keyvault.bicep' = {
  name: '${deployment().name}-infra-keyvault'
  params: {
    vaultName: keyvaultName
    location: location    
  }
}

module serviceBus 'servicebus.bicep' = {
  name: '${deployment().name}-infra-servicebus'
  params: {
    name: serviceBusName
    location: location
  }
}

module containerAppsEnvironment 'container-apps-env.bicep' = {
  name: '${deployment().name}-infra-container-app-env'
  params: {
    containerAppsEnvironmentName: containerAppsEnvironmentName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    location: location
  }
}
