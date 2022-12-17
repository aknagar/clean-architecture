param location string
param uniqueSeed string
param containerAppsEnvironmentName string = 'containerappenv-${uniqueString(uniqueSeed)}'
param logAnalyticsWorkspaceName string = 'loganalytics-${uniqueString(uniqueSeed)}'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
  name: containerAppsEnvironmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
  }
}

output containerAppsEnvironmentId string = containerAppsEnvironment.id
output containerAppsEnvironmentDomain string = containerAppsEnvironment.properties.defaultDomain
