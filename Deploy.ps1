cls

<# 

Deployment Scripts : Backups
By: Chris Teater
05/16/2016

#>

Do {
    #Prompts users to select which servers the backups need to be run on
    Do {
        "Which servers do these backups need to be run on?
        1. Staging Web
        2. Staging App
        3. Production Web
        4. Production App
        5. Local Web
        6. Incidental

        Please enter 1, 2, 3, 4, 5, or 6:
        "

        #Prompts user to enter a 1, 2, 3, 4, or 5 to select text file containing server names
        $GetServers = Read-Host ">"

        switch ($GetServers)
        {
            1 { $ServerList = "C:\Powershell\StageWeb.txt" }
            2 { $ServerList = "C:\Powershell\StageApp.txt" }
            3 { $ServerList = "C:\Powershell\ProdWeb.txt" }
            4 { $ServerList = "C:\Powershell\ProdApp.txt" }
            5 { $ServerList = "C:\Powershell\BreweryWeb.txt" }
            6 { $ServerList = "C:\Powershell\Other.txt" }
            Default { "$GetServers is not a valid option." }
        }
    } until ($GetServers -eq 1 -or $GetServers -eq 2 -or $GetServers -eq 3 -or $GetServers -eq 4 -or $GetServers -eq 5 -or $GetServers -eq 6)


    #Gets Application that is being backed up3
    $Application = Read-Host "Enter Application Folder Name"

    $Verify = "N"
    $Verify = read-host "You have selected $ServerList and $Application : Do you wish to Proceed? (Y/N)"

} until ( $Verify -eq "Y")

#calls file that contains the fucntions
. "C:\powershell\DeployFunctions.ps1"

#Checks to see if backups are wanted
do {
    $MakeBackups = Read-Host "Do you want to make backups of the application? (Y/N)"
    } until ($MakeBackups.ToLower() -eq 'n' -or $MakeBackups.ToLower() -eq 'y')

#Calls the backup-files function
if ($MakeBackups.ToLower() -eq 'y') {
    Backup-Files -Folder $Application -Servers $ServerList
    }

#Asking if user wants to delete contents of app folder
do {
    $VerifyDelete = Read-Host "Do you want to delete the files and folders in the application? (Y/N)"
    } until ($VerifyDelete.ToLower() -eq 'n' -or $VerifyDelete.ToLower() -eq 'y')


#Gets source folder
$CopyType = Read-Host "Do you want to copy the application? (y/n)"

$SourceLoc = Read-Host "Enter the source CMR Number: "

#Calls delete files function
if ($VerifyDelete.ToLower() -eq 'y') {
    do {
        $yorn = Read-Host 'Delete Web.Config also? y/n'
    } until ($yorn.ToLower() -eq 'n' -or $yorn.ToLower() -eq 'y')

    Delete-Contents -Folder $Application -Servers $ServerList -DeleteWebConfig $yorn
}

if ($VerifyDelete.ToLower() -eq 'n') {

    Copy-Part -SourceLoc $SourceLoc -Servers $ServerList -folder $Application
                
}



Set-Location 'C:\Powershell'