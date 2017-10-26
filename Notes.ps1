# MY POWERSHELL NOTES

#region Title
# This makes it so that the code can be collapsed.  Can give it a title after region
#endregion

#region Cmdlets

Get-command

# narrow down search
Get-Command -verb "get"
Get-Command -Noun "service"

#Get-Help is key
Get-Help Get-Command
Get-Help Get-Command -examples
Get-Help Get-Command -Detailed
Get-Help Get-Command -Full
Get-Help Get-Command -Online

#Get-Help shortcut
Get-Command -?

#endregion Cmdlets

#region Alias

# Points to the cmdlet that dir references
Get-Alias dir

# Find all the aliases for a cmdlet
Get-Alias -Definition Get-ChildItem

#endregion

#region Pipeline

# Changes working directory
Set-Location "C:\Temp"

# Pipes allow stringing multiple cmdlets together
Get-ChildItem -recurse | Where-Object { $_.Length -gt 10kb } 
Get-ChildItem -recurse | Where-Object { $_.Length -gt 10kb } | Sort-Object length

# Pipes along with other cmdlets are particual about where line breaks and certain characters are.  The pipe has to be the last thing if it spans multiple lines.  Not even comments.
Get-ChildItem -Recurse |
    Where-Object { $_.Length -gt 10kb } |
    Sort-Object Lenght |
    Format-Table -Property Name, Length -AutoSize

# Use select-object to only return certain items.
Get-ChildItem | Select-Object Name, Lenght

# Backticks (tilde key) allow line breaks - % acts as alias for the foreach cmdlet
Get-ChildItem -Path 'C:\Program Files' -recurse `
              -File "*.txt" `
              -Verbose | % { Write-Host $_.FullName } |
              Format-Table -Property Name, Length -AutoSize

