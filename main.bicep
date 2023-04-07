param location string = 'uksouth'
param storageAccountName string = 'jrpcv${uniqueString(resourceGroup().id)}'
param profileName string = 'jrpcvcdn'
param endpointName string = 'jrpazurecv'

var url = take(storageaccount.outputs.storageAccountUrl, (length(storageaccount.outputs.storageAccountUrl)-1))

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
  name: '${profileName}/default'
  params: {
    location: 'global'
    cdnSku: 'Standard_Microsoft'
    endpointName: endpointName
    originUrl: substring(url, 8, (length(url)-8))
    profileName: profileName
  }
}

output storageAccountName string = storageAccountName
output storageAccountID string = storageaccount.outputs.storageAccountID
