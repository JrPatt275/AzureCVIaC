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

output storageAccountName string = storageAccountName
output storageAccountID string = storageaccount.outputs.storageAccountID
