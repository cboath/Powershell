cls

#Basics

$PSVersionTable

Get-Alias -definition Get-Content

Get-Command -Verb get

Get-Help Invoke-History

$HereIAm = Get-Location

Get-ChildItem | Out-GridView -PassThru -OutVariable WhereAmI

Write-Host "I am at $HereIAm\$whereAmI"

$HereIAm.GetType()

[int]$score = 21

$score

$score = "BlackJack"

#Here String

$lotsOfText = @"
    Text
    Text
    More text
"@


"Y914953" -match "Y[0-9]{6}"
"123-456-7890" -match "[0-9]{3}-[0-9]{3}-[0-9]{4}"
"Powershell" -like "Po?ershell"
"Teater" -like "Teate*[m-v]"

$TestArray = @(1..35)
$TestArray