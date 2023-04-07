$ErrorActionPreference = 'Stop'

$context = Get-AzContext -Name 'James R Patterson sub 1 (45fe69ba-142f-4256-aa8d-1fd47761c12c) - b4237b6a-7de5-4dd7-82c7-6de5917bc96f - James@jrpatterson.co.uk'
Set-AzContext $context
$storageAccount = Get-AzStorageAccount -ResourceGroupName $env:ResourceGroupName -AccountName $env:StorageAccountName

# Enable the static website feature on the storage account.
$ctx = $storageAccount.Context
Enable-AzStorageStaticWebsite -Context $ctx -IndexDocument $env:IndexDocumentPath -ErrorDocument404Path $env:ErrorDocument404Path

# Add the two HTML pages.
$tempIndexFile = New-TemporaryFile
Set-Content $tempIndexFile $env:IndexDocumentContents -Force
Set-AzStorageBlobContent -Context $ctx -Container '$web' -File $tempIndexFile -Blob $env:IndexDocumentPath -Properties @{'ContentType' = 'text/html'} -Force
$tempErrorDocument404File = New-TemporaryFile
Set-Content $tempErrorDocument404File $env:ErrorDocument404Contents -Force
Set-AzStorageBlobContent -Context $ctx -Container '$web' -File $tempErrorDocument404File -Blob $env:ErrorDocument404Path -Properties @{'ContentType' = 'text/html'} -Force