function Get-ADSIADGroup
{
<#
.Synopsis
   Get AD Group object using ADSI
.DESCRIPTION
   Not all servers and workstations have RSAT installed. This is a small function 
   using ADSI to get a group details via Name or DN.
   Only searches the current Domain this powershell session is a part of.
.INPUTS
  [String[]]
.EXAMPLE
  PS> Get-ADSIADGroup -Name "VRA_ADMINS"

  Path                                            Properties
  ----                                            ----------
  LDAP://CN=VRA_ADMINS,OU=Groups,DC=corp,DC=local {usnchanged, distinguishedname, di...


#>
[CmdletBinding(DefaultParameterSetName='Name')]
Param
(
    # the name of the group to find
    [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                ParameterSetName="Name",
                Position=0)]
    [String[]]
    $Name,
    [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                ParameterSetName="DN",
                Position=0)]
    [Alias("Path")]
    [String[]]
    $DN
)

    Begin
    {
    }
    Process
    {
        if ($PSCmdlet.ParameterSetName -eq "Name")
        {
            ([adsisearcher]"(&(objectclass=group)(name=*$Name*))").FindAll()
        }

        #does not work for some reason I cannot determine at this time
        if ($PSCmdlet.ParameterSetName -eq "DN")
        {
            ([adsisearcher]"(&(objectclass=group)(distinguishedname=*$DN*))").FindAll()
        }

    }
    End
    {
    }
}
