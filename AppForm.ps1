Add-Type -AssemblyName PresentationFramework

function Generate-Password(){
    for($i = 0; $i -lt 12; $i++){
    $rnd = (Get-Random(74))+48
    $char = [char]$rnd
    $pwd += $char
    }
    Return $pwd
}

function Set-Password($user, $password){
    Get-ADUser $user | Set-AdAccountPassword -reset -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force)
}

function Email-Password ($user, $email, $message){
    $subject = "New password for $user"
    $body = $message
    $cred = Get-Credential
    params = @{
        Body = $body
        BodyAsHtml = $true
        Subject = $subject
        From = 'me@mydomain.com'
        To = $email
        SmtpServer = 'my.domain.com'
        Port = 587
        Credential = $cred
        UseSsl = $true
        }
    Send-MailMessage @params
}


[xml]$form = Get-Content "D:\App.xaml"
$NR = (New-Object System.Xml.XmlNodeReader $form)
$Win = [Windows.Markup.XamlReader]::Load( $NR )

$user = $Win.FindName("UserName")
$pwd = $Win.FindName("Password")
$gen = $Win.FindName("GeneratePassword")
$update = $Win.FindName("Update")

$gen.Add_Click({
$password = Generate-Password
$pwd.text = $password
})

$update.Add_Click({
Try{$usr = Get-Aduser $user.text -Properties EmailAddress}Catch{$usr=$null}
$alias = $usr.SamAccountName
$email = $usr.EmailAddress
$password = $pwd.Text
if($password -eq ""){
[System.Windows.MessageBox]::Show("Please generate password", "Password Error")
}ElseIf($usr -eq $null){
[System.Windows.MessageBox]::Show("Please enter a valid username", "User Error")
}Else{
Set-Password $alias $password
$message = "Your password has been changed to $password.  You will need to change it at first logon."
Email-Password $alias $email $message
[System.Windows.MessageBox]::Show("Email has been sent to $alias", "Success")
}})

$Win.ShowDialog() 