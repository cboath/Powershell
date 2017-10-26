Add-Type -AssemblyName PresentationFramework

Function Get-SysTab($computer){
$sys = Get-CimInstance win32_operatingsystem | select-object Caption, installdate, Servicepackmajorversion
$os.content = $sys.caption
$Inst.content =$sys.installdate
$sp.content = $sys.Servicepackmajorversion
}

Function Get-EventTab($computer){
$ev = get-eventlog application -ComputerName $computer -newest 100 | select TimeGenerated, EntryType, Source, InstanceID | sort -property Time
Return $ev
}

Function Get-ProcTab($computer){
$proc = Get-Process -ComputerName $computer| select ID,Name,CPU | Sort -Property Name
Return $proc
}

[xml]$form = Get-Content "D:\AppWithTabs.xaml"
$NR = (New-Object System.Xml.XmlNodeReader $form)
$Win = [Windows.Markup.XamlReader]::Load( $NR )

$computer = $win.FindName("ComputerName")
$start = $win.FindName("Start")
$os = $win.FindName("OS")
$Inst = $win.FindName("InstallDate")
$sp = $win.FindName("ServicePack")
$edg = $win.FindName("EVdataGrid")
$pdg = $win.FindName("ProcdataGrid")

$arrev = New-Object System.Collections.ArrayList
$arrproc = New-Object System.Collections.ArrayList

$start.add_click({
$comp = $computer.Text
Get-Systab $comp
$events= Get-EventTab $comp
$arrev.addrange($events)
$edg.ItemsSource=@($arrev)
$Procs = Get-ProcTab $comp
$arrproc.addrange($Procs)
$pdg.ItemsSource=@($arrproc)
})

$Win.ShowDialog()