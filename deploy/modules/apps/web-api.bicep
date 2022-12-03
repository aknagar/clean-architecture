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

/*@secure()
param serviceBusConnectionString string
*/

resource containerApp 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: 'weatherforecast-api'
  location: location
  properties: {
    managedEnvironmentId: containerAppsEnvironmentId
    template: {
      containers: [
        {
          name: 'v2022-11-15'
          image: 'aknagar/v2022-11-15:1.0.0'
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
      ingress: {
        external: true
        targetPort: 80
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      /*
      secrets: [        
        {
          name: 'service-bus-connection-string'
          value: serviceBusConnectionString
        }
      ]
      */
    }
  }
}
