function Export-PSCredentialCleartextPassword
{
<#
.SYNOPSIS
  Create a credential file by passing a clear text password.
.DESCRIPTION
  Create a credential file by passing a clear text password, specifically for
  use when needing to run a powershell script as SYSTEM such as a scheduled
  task and you require additional credentials.
.NOTES
  Author: Clint Fritz
  Process:
    1. Copy this function into a new temporary powershell script.
    2. Under the function run the function with the required details
    3. Save the script
    4. Create a scheduled task to run as SYSTEM configure to run the script
    5. Overwrite the password in the temporary script with other text and save (so the file cannot be restored from the Recycle Bin)
    6. Delete the temporary powershell script
  Note: This credential file will only work on the system it was created on.
.EXAMPLE
  Export-PSCredentialCleartextPassword -Username "myuser" -Password "myPassword" -Path "C:\Temp\cred_etcd.xml"
#>
param ( 
    [Parameter(Mandatory=$true)]
    [string]$Username,

    [Parameter(Mandatory=$true)]
    [String]$Password,
    
    $Path = "credentials.enc.xml" 
)

    # Create temporary object to be serialized to disk
    $export = "" | Select-Object Username, EncryptedPassword
 
    # Give object a type name which can be identified later
    $export.PSObject.TypeNames.Insert(0,'ExportedPSCredential')

    $export.Username = $Username
 
    # Encrypt clear test password using Data Protection API
    # Only the current user account can decrypt this cipher
    $export.EncryptedPassword = $Password | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString

    # Export using the Export-Clixml cmdlet
    $export | Export-Clixml $Path

    #Return FileInfo object referring to saved credentials
    #Write-Output "Credentials saved to: $($Path)"
    #Get-Item $Path
}
