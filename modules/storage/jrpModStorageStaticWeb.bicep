@description('The location where the resources should be deployed')
param location string
param storageAccountName string

@description('These will be passed as environmental variables to the powershell script')
param IndexDocPath string
param IndexDocContents string
param ErrorDocPath string
param ErrorDocContents string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

resource deploymentScriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'deploymentScript'
  location: location
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storageAccount
  name: guid(resourceGroup().id, deploymentScript.id, subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab'))
  properties: {
    roleDefinitionId: subscriptionResourceId('microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')
    principalId: deploymentScriptIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'deploymentScript'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${deploymentScriptIdentity.id}' : {}
    }
  }
  properties: {
    azPowerShellVersion: '8.3'
    primaryScriptUri: 'https://raw.githubusercontent.com/JrPatt275/AzureCVIaC/staticweb/scripts/enablestaticweb.ps1'
    retentionInterval: 'PT4H'
    environmentVariables: [
      {
        name: 'ResourceGroupName'
        value: resourceGroup().name
      }
      {
          name: 'StorageAccountName'
          value: storageAccountName
      }
      {
        name: 'IndexDocPath'
        value: IndexDocPath
      }
      {
        name: 'IndexDocContents'
        value: IndexDocContents
      }
      {
        name: 'ErrorDocPath'
        value: ErrorDocPath
      }
      {
        name: 'ErrorDocContents'
        value: ErrorDocContents
      }
    ]

  }
  dependsOn: [
    storageAccount
  ]
}

output endpoint string = storageAccount.properties.primaryEndpoints.web
