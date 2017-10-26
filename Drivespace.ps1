cls

$unit = "GB"
$measure = "1$unit"
$wmiQuery = "SELECT SystemName, Name, DriveType, Filesystem, FreeSpace, Capacity, Label FROM Win32_Volume"

Get-WmiObject -Query $wmiQuery |
    Select-Object SystemName, Name, Label, DriveType, Filesystem ,
        @{Label="SizeIn$unit";Expression={"{0:n2}" -f ($_.Capacity/$Measure)}},
        @{Label="FreeIn$unit";Expression={"{0:n2}" -f ($_.freespace/$Measure)}},
        @{Label="PercentFree";Expression={"{0:n2}" -f (($_.freespace/$_.Capacity)*100)}} |
  #  Where-Object { $_.Name -notlike '\\?\*' } |
    Sort-Object Name |
    Format-Table -AutoSize -Property SystemName, Name, Label, DriveType, Filesystem,
        @{Label="Size In $unit";Align="Right";Exp={($_."SizeIn$Unit")}} ,
        @{Label="Free In $unit";Align="Right";Exp={($_."FreeIn$Unit")}} ,
        @{Label="Precent Free";Align="Right";Exp={($_.PercentFree)}}