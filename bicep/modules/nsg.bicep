param nsgname string
param nsgrules array
param location string
param nsgstore string
param logAnalyticsworkspacecustid string

resource storage 'Microsoft.Storage/storageAccounts@2021-08-01' existing = {
  name: nsgstore
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: nsgname
  location: location
  properties: {
    securityRules:  nsgrules
  }
}
resource nsglogs 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: networkSecurityGroup
  name: 'service' 
  properties: {
    logs: [
      {
        category: 'NetworkSecurityGroupEvent'
        enabled: true
        retentionPolicy: {
          days: 7
          enabled: true
        }
      }
      {
        category: 'NetworkSecurityGroupRuleCounter'
        enabled: true
        retentionPolicy: {
          days: 7
          enabled: true
        }
      }
    ]
    storageAccountId: resourceId('Microsoft.Storage/storageAccounts', nsgstore)
    workspaceId: logAnalyticsWorkspaceId
  }
}


output nsgid string =networkSecurityGroup.id
output nsgname string =networkSecurityGroup.name

@description('Flow Log name')
param flowlogName string = 'flowlog'


@description('Network Watcher name')
param networkWatcherName string = 'NetworkWatcher_${location}'

@description('Network Watcher Resource Group')
param networkWatcherResourceGroup string = 'NetworkWatcherRG'

@description('Network Security Group resource id')
var existingNsgId = networkSecurityGroup.id

@description('Storage account resource id')
var existingFlowLogStorageAccountId = storage.id

@description('Log analytics workspace resource id')
param logAnalyticsWorkspaceId string
module flowLogs 'flowlogs.bicep' = {
  name: '${nsgname}deployFlowLogs'
  scope: resourceGroup(networkWatcherResourceGroup)
  params: {
    flowlogName: '${nsgname}${flowlogName}'
    location: location
    networkWatcherName: networkWatcherName
    existingNsgId: existingNsgId
    existingFlowLogStorageAccountId: existingFlowLogStorageAccountId
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    logAnalyticsworkspacecustid: logAnalyticsworkspacecustid
  }
}
