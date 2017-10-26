#Go to microsoft to download the web platform installer and get Azure powershell standalone

get-module -ListAvailable *azure*

get-azurepublishsettingsfile
Import-AzurePublishSettingsFile -PublishSettingsFile "D:\PSDemo\Pay-As-You-Go-12-2-2016-credentials.publishsettings"

get-azuresubscription

Get-AzureVM

Get-AzureVM | Where {$_.Name -like "*DBS*"} | Start-AzureVM

get-azurestorageaccount