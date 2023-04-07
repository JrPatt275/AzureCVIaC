param location string = 'uksouth'
param storageAccountName string = 'jrpcv${uniqueString(resourceGroup().id)}'
param profileName string = 'jrpcvcdn'
param endpointName string = 'jrpcvcdnendpoint'

module storageaccount 'modules/storage/jrpModStorage.bicep' = {
  name: 'storageAccount'
  params: {
    location: location
    storageAccountName: storageAccountName
    storageAccountSku: 'Standard_LRS'
    storageAccountKind: 'StorageV2'
  }
}

module cdn 'modules/storage/jrpModCDN.bicep' = {
  name: profileName
  params: {
    cdnSku: 'Standard_Microsoft'
    endpointName: '${profileName}/${endpointName}'
    location: location
    originUrl: storageaccount.outputs.storageAccountUrl
    profileName: profileName
  }
}

output storageAccountName string = storageAccountName
output storageAccountID string = storageaccount.outputs.storageAccountID
