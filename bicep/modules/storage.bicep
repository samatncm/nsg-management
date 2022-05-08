param storageaccountname string
param location string
param sku string 
// param subnetid string
resource storage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageaccountname
  location: location
  kind: 'StorageV2'
  sku: {
    name: sku
  }
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      //  Optional for network isolation commented out for example
      // virtualNetworkRules: [
      //   {
      //     id: subnetid
      //     action: 'Allow'
      //     state: 'Succeeded'
      //   }
      // ]
      ipRules: []
      defaultAction: 'Deny'
    }
    allowBlobPublicAccess:false
    minimumTlsVersion: 'TLS1_2'
  }
}
output StorageId string = storage.id
