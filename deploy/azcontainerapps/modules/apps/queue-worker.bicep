param location string
// param seqFqdn string

param containerAppsEnvironmentId string
param containerAppsEnvironmentDomain string

/*
param cosmosDbName string
param cosmosCollectionName string
param cosmosUrl string
@secure()
param cosmosKey string
*/

@secure()
param serviceBusConnectionString string


resource containerApp 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: 'queue-worker'
  location: location
  properties: {
    managedEnvironmentId: containerAppsEnvironmentId
    template: {
      containers: [
        {
          name: 'dotnet-queue-worker'
          image: 'aknagar/dotnet-queue-worker:1.0.0'
          resources: {
            cpu: json('0.5')
            memory: '1.0Gi'
          } 
          env: [
            {
              name: 'ASPNETCORE_ENVIRONMENT'
              value: 'Development'
            }
            {
              name: 'ASPNETCORE_URLS'
              value: 'http://0.0.0.0:80'
            }            
            {
              name: 'IdentityUrl'
              value: 'https://identity-api.${containerAppsEnvironmentDomain}'
            }  
            {
              name: 'IdentityUrlExternal'
              value: 'https://identity-api.${containerAppsEnvironmentDomain}'
            }
            {
              name: 'SERVICEBUS_AUTH_MODE'
              value: 'ConnectionString'
            }
            {
              name: 'SERVICEBUS_QUEUE_NAME'
              value: 'orders'
            }
            {
              name: 'SERVICEBUS_QUEUE_CONNECTIONSTRING'
              secretRef: 'service-bus-connection-string'
            }
            /*
            {
              name: 'SeqServerUrl'
              value: 'https://${seqFqdn}'
            }
            */
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
    configuration: {      
      secrets: [        
        {
          name: 'service-bus-connection-string'
          value: serviceBusConnectionString
        }
      ]
    }
  }
}
