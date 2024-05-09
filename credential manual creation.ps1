
$username = "loginid@corp.local"
$password = "password"

New-Variable -Name "cred_loginid_corp" -Value $(New-Object System.Management.Automation.PSCredential ($username, $Password)) -Scope global
