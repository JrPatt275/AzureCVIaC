@description('The region where the storage account should be deployed')
param location string

@description('The name of the storage account')
param storageAccountName string

@description('The storage account Sku')
@allowed([
  'Standard_LRS'
  'Premium_LRS'
  'Standard_ZRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
])
param storageAccountSku string

@description('The storage account kind')
@allowed([
  'Storage'
  'StorageV2'
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
])
param storageAccountKind string

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: storageAccountKind
  sku: {
    name: storageAccountSku
  }
}

output storageAccountName string = storageAccountName
output storageAccountID string = storageaccount.id
