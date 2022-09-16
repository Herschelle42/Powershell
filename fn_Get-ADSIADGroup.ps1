function Get-ADSIADGroup
{
<#
.SYNOPSIS
   Get AD Group object using ADSI
.DESCRIPTION
   Not all servers and workstations have RSAT installed. This is a small function 
   using ADSI to get a group details via Name or DN.
   Only searches the current Domain this powershell session is a part of.
.PARAMETER Name
  Name or partial name of the group to search for.
.PARAMETER DN
  The DN of the group to search for.
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
        Write-Verbose "$(Get-Date) Begin"
        Write-Verbose "$(Get-Date) ParameterSet: $($PSCmdlet.ParameterSetName)"
    }
    Process
    {

        if ($PSCmdlet.ParameterSetName -eq "Name")
        {
            $searchResult = foreach ($itemName in $Name)
            {
                Write-Verbose "$(Get-Date) ItemName: $($itemName)"
                ([adsisearcher]"(&(objectclass=group)(name=*$itemName*))").FindAll()
            }
        }

        #does not work for some reason I cannot determine at this time
        if ($PSCmdlet.ParameterSetName -eq "DN")
        {
            $searchResult = foreach ($itemName in $DN)
            {
                Write-Verbose "$(Get-Date) ItemName: $($itemName)"
                ([adsisearcher]"(&(objectclass=group)(distinguishedname=*$itemName*))").FindAll()
            }
        }

        Write-Verbose "$(Get-Date) Returning result as powershell object"
        #create a custom object
        foreach ($item in $searchResult)
        {
            $hash = [ordered]@{}
            $hash.PSTypeName = "Group.Information"
            $hash.Path = $item.Path
            foreach ($keyName in $item.Properties.Keys | Sort)
            {
                $hash.$($keyName) = $item.Properties | % { $_.$keyName }
            }

            #for some reason, some groups do not show members under member but some strange variation.
            if(-not($hash.member) -and ($hash.Keys | ? { $_ -match "member;range" }) ) {
                $keyName = $hash.Keys | ? { $_ -match "member;range" }
                $hash.member = $hash.$($keyname)
            }
            $object = New-Object -TypeName PSObject -Property $hash
            $object
        }

    }
    End
    {
        Write-Verbose "$(Get-Date) End"
    }
}
