var object = json(loadTextContent('../resources/nw-objects.json'))
var ports = json(loadTextContent('../resources/nw-ports.json'))

param orgprefix string = 'ncm'
param env string = 'dev'
param location string = 'uksouth'
param tags object = {
  'env': 'dev'
}

var nsgstore = '${orgprefix}${env}nsglog001'
var workspacename = '${orgprefix}${env}nsgworkspace001'
module loganalytics 'modules/logworkspace.bicep' = {
  name: 'workspace-deployment'
  params: {
    location: location
    name: workspacename
    tags: tags
  }
}
module nsglogstore 'modules/storage.bicep' = {
  name: 'nsgstore-deploy'
  params: {
    location: location
    storageaccountname: nsgstore
  }
}
module devnsg 'modules/nsg.bicep' = {
  name: 'devnsg'
  params: {
    location: location
    nsgname: 'devnsg'
    nsgrules: [
      {
        name: 'AllowTrustedHTTPS'
        properties: {
          description: 'Allow Trusted HTTP HTTPS traffic'
          access: 'Allow'
          destinationAddressPrefixes: object.trusted
          destinationPortRanges: union(ports.http,ports.https)
          direction: 'Inbound'
          priority: 200
          protocol: 'TCP'
          sourceAddressPrefixes: object.untrusted
          sourcePortRange: '*'
          sourcePortRanges: []
          sourceApplicationSecurityGroups: []
          destinationApplicationSecurityGroups: []
        }
      }
    ]
    nsgstore: nsgstore
    logAnalyticsworkspacecustid: loganalytics.outputs.custid
    logAnalyticsWorkspaceId: loganalytics.outputs.logId
  }
}
