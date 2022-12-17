param name string
param location string

resource servicebus 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}
/*
resource ordersTopic 'Microsoft.ServiceBus/namespaces/topics@2021-06-01-preview' = {
  name: 'orders'
  parent: servicebus
  properties: {
    defaultMessageTimeToLive: 'P6M' //ISO 8601
    status: 'Active'
  }
}
*/
resource ordersQueue 'Microsoft.ServiceBus/namespaces/queues@2022-01-01-preview' = {
  name: 'orders'
  parent: servicebus
  properties: {
    defaultMessageTimeToLive: 'P6M' //ISO 8601
    status: 'Active'
  }
}

output servicebusId string = servicebus.id
output servicebusName string = servicebus.name
output apiVersion string = servicebus.apiVersion



