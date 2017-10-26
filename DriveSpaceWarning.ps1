$wmiQuery = "SELECT SystemName, Name, DriveType, Filesystem, FreeSpace, Capacity, Label FROM Win32_Volume"

Get-WmiObject -Query $wmiQuery |

        ForEach-Object {
        $size = $_.freespace
        $cap = $_.capacity
        $total = $size / $cap
        if ($TOTAL * 100 -lt 60) {

        wriTe-Host "Danger!!!!" } Else { Write-Host "All Good...." }
        }