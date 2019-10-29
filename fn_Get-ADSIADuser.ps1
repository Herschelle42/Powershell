function Get-ADSIADuser
{
<#
.Synopsis
   Get AD User object using ADSI
.DESCRIPTION
   Not all servers and workstations have RSAT installed. This is a small function 
   using ADSI to get a user details via Name or SamAccountName.
   Only searches the current Domain this powershell session is a part of.
.INPUTS
  [String[]]
.EXAMPLE
  PS> Get-ADSIADUser -Name "Jane Doe"

  Path                                         Properties
  ----                                         ----------
  LDAP://CN=Jane Doe,OU=Users,DC=corp,DC=local {lastlogoff, ms-ds-consistencyguid, departme...

.EXAMPLE
  PS> Get-ADSIADUser -SamAccountName "jd001"

  Path                                         Properties
  ----                                         ----------
  LDAP://CN=Jane Doe,OU=Users,DC=corp,DC=local {lastlogoff, ms-ds-consistencyguid, departme...
  
#>
[CmdletBinding(DefaultParameterSetName='Name')]
Param
(
    # This is the display Name of the person (usually <first> <last>)
    [Parameter(Mandatory=$true,
                ParameterSetName='Name',
                Position=0)]
    [String[]]
    $Name,

    # Param1 help description
    [Parameter(Mandatory=$true,
                ParameterSetName='SAM',
                Position=0)]
    [Alias("UserId","LogonId","Logon")]
    [String[]]
    $SamAccountName
)

    Begin
    {
    }
    Process
    {
        if ($PSCmdlet.ParameterSetName -eq "SAM")
        {
            ([adsisearcher]"(&(objectClass=user)(samaccountname=*$SamAccountName*))").FindAll()
        }
        if ($PSCmdlet.ParameterSetName -eq "Name")
        {
            ([adsisearcher]"(&(objectClass=user)(name=*$Name*))").FindAll()
        }
    }
    End
    {
    }
}
