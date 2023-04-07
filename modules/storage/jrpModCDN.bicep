@description(' The location in which to deploy the resources')
param location string = 'global'

@description('Name of the CDN profile')
param profileName string

@description('Name of the endpoint. Must be unique')
param endpointName string

@description('URL of the origin')
param originUrl string

@description('CDN Sku')
@allowed([
  'Standard_Akamai'
  'Standard_Microsoft'
  'Standard_Verizon'
  'Premium_Verizon'
])
param cdnSku string

resource profile 'Microsoft.Cdn/profiles@2022-11-01-preview' = {
  name: profileName
  location: location
  sku:{
    name: cdnSku
  }
}

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2021-06-01' = {
  name: endpointName
  location: location
  properties: {
    originHostHeader: originUrl
    isHttpAllowed: true
    isHttpsAllowed: true
    queryStringCachingBehavior: 'IgnoreQueryString'
    isCompressionEnabled: true
    contentTypesToCompress: [
      'application/eot'
      'application/font'
      'application/font-sfnt'
      'application/javascript'
      'application/json'
      'application/opentype'
      'application/otf'
      'application/pkcs7-mime'
      'application/truetype'
      'application/ttf'
      'application/vnd.ms-fontobject'
      'application/xhtml+xml'
      'application/xml'
      'application/xml+rss'
      'application/x-font-opentype'
      'application/x-font-truetype'
      'application/x-font-ttf'
      'application/x-httpd-cgi'
      'application/x-javascript'
      'application/x-mpegurl'
      'application/x-opentype'
      'application/x-otf'
      'application/x-perl'
      'application/x-ttf'
      'font/eot'
      'font/ttf'
      'font/otf'
      'font/opentype'
      'image/svg+xml'
      'text/css'
      'text/csv'
      'text/html'
      'text/javascript'
      'text/js'
      'text/plain'
      'text/richtext'
      'text/tab-separated-values'
      'text/xml'
      'text/x-script'
      'text/x-component'
      'text/x-java-source'
    ]
    origins: [
      {
        name: endpointName
        properties: {
          hostName: originUrl
        }
      }
    ]
  }
  dependsOn: [
    profile
  ]
}
