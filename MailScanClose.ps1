function Get-DateHack ($DateString) {
    $DateHack = $DateString.Split(" ")
    Get-Date -Date ("{0} {1}{2}" -f $DateHack[0], $DateHack[2], $DateHack[3])
}

$olFolderInbox = 6
$outlook = new-object -com outlook.application;
$ns = $outlook.GetNameSpace("MAPI");
$inbox = $ns.GetDefaultFolder($olFolderInbox)
$targetfolder = $inbox.Folders | where-object { $_.name -eq "CMRTEST" }

$targetfolder.items |
    Select-Object -ExpandProperty body |
    Where-Object { $_ | Select-String "(Implementer.*TEATER)"} | where { $_ | Select-String "(Request Status.*Approved)"}
    ForEach-Object {
        $MailBody = $_
        $OutObject = New-Object psobject

        $MailBody.Split("`n") |
            Where-Object { ($_ -match "Date") -or ($_ -match "Request") } |
            ForEach-Object {
                $Key, $Values = $_.Split(":")
                $Value = $Values -join ":"
                $OutObject | Add-Member -MemberType NoteProperty -Name $Key.Trim() -Value $Value.Trim()
            }

        $OutObject | Add-Member -MemberType NoteProperty -Name "StartDate" -Value (Get-DateHack $OutObject.'Start Date')
        $OutObject | Add-Member -MemberType NoteProperty -Name "EndDate" -Value (Get-DateHack ($OutObject.'End Date'))

        $newAppt = $outlook.CreateItem("olAppointmentItem")
        $newAppt.Body = $MailBody
        $newAppt.Subject = "{0} {1}" -f $OutObject.'Request Type', $OutObject.'Change Request ID'
        $newAppt.Start = $OutObject.StartDate
        $newAppt.End = $OutObject.EndDate
        $newAppt.Save()
    }
