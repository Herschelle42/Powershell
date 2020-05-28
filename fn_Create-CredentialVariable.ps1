function Create-CredentialVariable
{
<#
.SYNOPSIS 
  Loads cred*.xml files as variables into the powershell instance
.DESCRIPTION
  Imports all the cred*.xml files in the directory specified and creates a 
  variable for each file using the file name as the variable name.
  For example:  cred_mycred.xml
  becomes:      $cread_mycred
  This variable is created in the global scope and will overwrite any existing
  variables of the same name.
.NOTES
  Author:   Clint Fritz
  Requires Hal Rottenburgs @halr9000 Import-PSCredential function
  https://github.com/halr9000
  https://www.powershellgallery.com/packages/Office365PowershellUtils/1.1.5/Content/PSCredentials.psm1
.EXAMPLE
  Create-CredentialVariable -Path C:\Data\Scripts\
#>
  [CmdletBinding()]
  param ( 
    [Parameter(Mandatory=$true,
      HelpMessage='Path to the credential files cred*.xml',
      ValueFromPipelineByPropertyName=$true,
      ValueFromPipeline=$true)]
      [Alias('FilePath','Directory')]
      [string[]]$Path
  ) 

  $credlist = Get-ChildItem $path cred*.xml -Name
    if ($credlist) 
    {
        foreach ( $credfile in $credlist ) {
            $credvar = ($credfile.substring(0,($credfile.indexof("."))))
            New-Variable -Name $credvar -Scope Global -Value (Import-PSCredential $path\$credfile) -force
            Write-Output $credvar
        } #end foreach
    } else {
      Write-Output "No credential files found."
    } 

}
