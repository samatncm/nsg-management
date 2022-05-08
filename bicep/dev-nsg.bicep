var object = json(loadTextContent('../resources/nw-objects.json'))
var ports = json(loadTextContent('../resources/nw-ports.json'))

param orgprefix string = 'ncm'
param env string = 'dev'
param location string = 'uksouth'
param tags object = {
  'env': 'dev'
}

var nsgstore = '${orgprefix}${env}nsglog001'
module loganalytics 'modules/logworkspace.bicep' = {
  name: 
  params: {
    location: location
    name: env
    tags: tags
  }
}
module nsglogstore 'modules/storage.bicep' = {
  name: 
  params: {
    location: 
    sku: 
    storageaccountname: 
  }
}
module devnsg 'modules/nsg.bicep' = {
  name: devnsg
  params: {
    location: 
    nsgname: 
    nsgrules: [
      {
        name: 'AllowTrustedHTTPS'
        properties: {
          description: 'Allow Trusted HTTPS traffic'
          access: 'Allow'
          destinationAddressPrefixes: object.
          destinationPortRanges: ports.
          direction: 'Inbound'
          priority: 200
          protocol: 'TCP'
          sourceAddressPrefixes: 
          sourcePortRange: '*'
          sourcePortRanges: []
          sourceApplicationSecurityGroups: []
          destinationApplicationSecurityGroups: []
        }
      }
    ]
    nsgstore: 
    workspaceid: 
  }
}
