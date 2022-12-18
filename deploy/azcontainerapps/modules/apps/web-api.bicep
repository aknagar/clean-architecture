param location string
// param seqFqdn string

param containerAppsEnvironmentId string
param containerAppsEnvironmentDomain string

@secure()
param clientsecret string

resource containerApp 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: 'ordering-webapi'
  location: location
  // identity: 'ManagedServiceIdentity'
  properties: {
    managedEnvironmentId: containerAppsEnvironmentId
    template: {
      containers: [
        {
          name: 'ordering-webapi'
          image: 'aknagar/ordering-webapi:1.0.2'
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
              name: 'SERVICEBUS_AUTH_MODE'
              value: 'ConnectionString'
            }
            {
              name: 'SERVICEBUS_QUEUE_NAME'
              value: 'orders'
            }
            {
              name: 'ClientSecret'
              secretRef: 'clientsecret'
            }
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
      secrets: [        
        {
          name: 'clientsecret'
          value: clientsecret
        }
      ]
    }
    
  }
}
