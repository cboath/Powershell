while ($true) {

cls

$user = ""
$password = ""

$ie = new-object -ComObject 'internetExplorer.application'
$ie.Visible = $true
$ie.Navigate("https://www.engagedaugherty.com/index.php")

while ($ie.busy -eq $true) {Start-Sleep -Seconds 1}

$ie.document.getElementsByTagName("input") | ? {$_.name -eq 'L_User'} | % {$_.value = $user}
$ie.document.getElementsByTagName("input") | ? {$_.name -eq 'L_Pass'} | % {$_.value = $password}
$ie.document.getElementsByTagName("input") | ? { $_.type -eq 'submit'} | % { $_.Click() }

start-sleep -Seconds 10

$ie.Navigate("https://www.engagedaugherty.com/user-area/leaderboard.php")

Start-Sleep -Seconds 3

$ie.Quit()

start-sleep -Seconds 3600
}
#$ie.Document.body | out-file -FilePath C:\ttr\web.txt
