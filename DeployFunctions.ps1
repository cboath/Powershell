#------------------------------ DELETE FUNCTION ------------------------------#

try {
    function Delete-Contents {
        param (
            [string]$folder,
            [string]$DeleteWebConfig,
            [string[]]$exclusions,
            [string]$Servers
        )

        #Sets the exclusions
        $exclusions = '_PreviousVersions'

        if ($DeleteWebConfig.tolower() -eq 'n') {
            $exclusions += 'web.config'
        }

        Get-Content $Servers | foreach {
            $AppCurrLoc = "\\$_\f$\srvapps\webdata\wwwroot\$folder"

            Set-Location $AppCurrLoc

            Write-Host "Deleting files from $_"

            Get-ChildItem $AppCurrLoc -Exclude $exclusions | ForEach-Object {
                Remove-Item $_.FullName -Force -Recurse -Verbose
            }

            $Removalpath = "\\$_\f$\srvapps\webdata\wwwroot\$folder\_PreviousVersions"

            Get-ChildItem $Removalpath  |
                Sort-Object { $_.Name } -Descending |
                Select-Object -Skip 5 |
                Remove-Item -Recurse -force -Verbose

                

            #Does everything get passed correctly?
            if ( $CopyType.ToLower() -eq 'y' ) {    

                Copy-All -SourceLoc $SourceLoc -Servers $ServerList -folder $Application
                Write-Host "Copying files to $_"
            }
        }
    }
} Catch
    {
        Write-Host "An error has occured!"
        Write-Host $_.ErrorID
        Write-Host $_.Exception.Message
        #Break to exit loop
    }


#------------------------------ BACKUP FUNCTION ------------------------------#

function Backup-Files {
    param (
        [string]$folder,
        [string]$Servers
    )

    #Write-Host "So far, we have gotten that you selected $folder and $Servers"

try
{
#Only compare files on first server
$ValidateCounter = 0

Get-Content $ServerList | foreach {
    
    $ValidateCounter += 1

     #Sets Boolean value for if the path exists or not
        $ValidPath = Test-Path \\$_\f$\srvapps\webdata\wwwroot\$Application\_PreviousVersions

        #If _PreviousVersions does not exist, it creates the folder
        if($ValidPath -eq 0) {
        New-Item -ItemType Directory -Path \\$_\f$\srvapps\webdata\wwwroot\$Application\_PreviousVersions }

        #Checking to see if the date folder exists
     
        $today = (Get-Date).ToString('yyyyMMdd')

        #Sets Boolean value for if the path exists or not
        $ValidDatePath = Test-Path \\$_\f$\srvapps\webdata\wwwroot\$Application\_PreviousVersions\_PreviousVersion_$today

        $FolderCounter = 1
        $FinalName = $today
        
        #Checks to see if path exists.  If not, creates it, if it does exist it steps through until it finds one that doesn't
        if($ValidDatePath -eq 1) {
            do {
                 $FolderCounter += 1
                 $finalName = $today+'R'+$FolderCounter

                 $ValidDatePath = Test-Path \\$_\f$\srvapps\webdata\wwwroot\$Application\_PreviousVersions\_PreviousVersion_$FinalName
               } until ($ValidDatePath -eq 0)
        }

        #Creates backup folder
        $CurrentBakLoc = New-Item -ItemType Directory -Path \\$_\f$\srvapps\webdata\wwwroot\$Application\_PreviousVersions\_PreviousVersion_$FinalName

        #Create variable to path of Application folder
        $AppLOC = "\\$_\f$\srvapps\webdata\wwwroot\$Application"
        #Create variable to path of backup destination
        $BackupLOC = "\\$_\f$\srvapps\webdata\wwwroot\$Application\_PreviousVersions"
        #Variable to exclude the _PreviousVersions folder from being backed up
        $ExcludeMatch = @("_PreviousVersions")

        Write-Host "Backing up files on $_"

        #Sets system location to _PreviousVersions folder so that backup goes in the right spot
        Set-Location $BackupLOC

        Get-ChildItem -Path $AppLOC -Recurse -Exclude $exclude |
                    where { $ExcludeMatch -eq $null -or $_.FullName.Replace($AppLOC, "") -notmatch $ExcludeMatch } |
                    Copy-Item -Destination {
                        if ($_.PSIsContainer) 
                        {
                            Join-Path $CurrentBakLoc $_.Parent.FullName.Substring($AppLOC.Length) }
                            else
                            {
                                Join-Path $CurrentBakLoc $_.FullName.Substring($AppLOC.Length)
                            }
                        } -Force -Exclude $ExcludeMatch

    #Compares files in backup folder to files in production folder on first server
    If($ValidateCounter % 2) {
        $CompareOrig = Get-ChildItem -Recurse $AppLOC -Exclude $exclude | where { $ExcludeMatch -eq $null -or $_.FullName.Replace($AppLOC, "") -notmatch $ExcludeMatch }
        $CompareNew = Get-ChildItem -Recurse $CurrentBakLoc

        Compare-Object $CompareOrig $CompareNew -Property Name, Length | Out-File $CurrentBakLoc\CompareLog.txt
        }
}
} Catch
    {
        Write-Host "An error has occured!"
        Write-Host $_.ErrorID
        Write-Host $_.Exception.Message
        #Break to exit loop
    }
}



<#------------------------------ ENTIRE COPY FUNCTION ------------------------------#>

try {
    function Copy-All {
        param (
            [string]$folder,
            [string]$SourceLoc,
            [string]$Servers
        )

    $SourcePath = "C:\AppReleases\$SourceLoc"
    
#Get-Content $ServerList | foreach {

    #Starts the copy
    $DestinationPath = "\\$_\f$\srvapps\webdata\wwwroot\$folder"

    robocopy $SourcePath $DestinationPath /s /NFL

    #}
}
} Catch
    {
        Write-Host "An error has occured!"
        Write-Host $_.ErrorID
        Write-Host $_.Exception.Message
        #Break to exit loop
    }


#------------------------------ PARTIAL COPY FUNCTION ------------------------------#

try {
    function Copy-Part {
        param (
            [string]$folder,
            [string]$SourceLoc,
            [string]$Servers
        )

    $SourcePath = "C:\AppReleases\$SourceLoc"
    
Get-Content $ServerList | foreach {

    #Starts the copy
    $DestinationPath = "\\$_\f$\srvapps\webdata\wwwroot\$folder"

    robocopy $SourcePath $DestinationPath /s /NFL

    }
}
} Catch
    {
        Write-Host "An error has occured!"
        Write-Host $_.ErrorID
        Write-Host $_.Exception.Message
        #Break to exit loop
    }

  