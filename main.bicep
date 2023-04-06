param location string = 'uksouth'
param storageAccountName string = 'jrpcv${uniqueString(resourceGroup().id)}'

module storageaccount 'modules/storage/jrpModStorage.bicep' = {
  name: 'storageAccount'
  params: {
    location: location
    storageAccountName: storageAccountName
    storageAccountSku: 'Standard_LRS'
    storageAccountKind: 'StorageV2'
  }
}

module staticweb 'modules/storage/jrpModStorageStaticWeb.bicep' = {
  name: 'staticWeb'
  params: {
    location: location
    storageAccountName: storageaccount.name
    IndexDocPath: 'index.html'
    IndexDocContents: '<h1>This is an Azure Storage Account Static Website</h1>'
    ErrorDocPath: 'error.html'
    ErrorDocContents: '<h1>Error 404 not found</h1>'
  }
}

output storageAccountName string = storageAccountName
output storageAccountID string = storageaccount.outputs.storageAccountID
output endpoint string = staticweb.outputs.endpoint
