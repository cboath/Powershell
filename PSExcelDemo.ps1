# collect excel process ids before and after new excel background process is started
$priorExcelProcesses = Get-Process -name "*Excel*" | % { $_.Id }
$Excel = New-Object -ComObject Excel.Application
$postExcelProcesses = Get-Process -name "*Excel*" | % { $_.Id }

cls

#Opens file to work with
$workfile = $excel.workbooks.open("D:\PSDemo\PSNumbers.xlsx")

$Sheetname = "Sheet1"

#Prevents excel from opening
$excel.Visible = $false

$sheet = $workfile.sheets.Item($Sheetname)

Write-host $sheet.Range("C4").Text

#Set starting cell
$col = "C"
$row = 2

#Loop through each row in Column C and if it is less than 0, colors cell red
do {

    $compVal = $sheet.Range("$col$row").Value()

    if ($compVal -lt 0) {
        $sheet.Range("$col$row").Interior.ColorIndex = 3
    }
    $row++
} until ($sheet.Range("$col$row").text -eq "")

#Saves file, won't overwrite
$workfile.SaveAs("D:\PSDemo\PSNumbers1.xlsx")

#Doesn't usually work
$excel.Quit()

#Works
$postExcelProcesses | ? { $priorExcelProcesses -eq $null -or $priorExcelProcesses -notcontains $_ } | % { Stop-Process -Id $_ }