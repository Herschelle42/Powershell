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

  accountexpires  : 9223372086854775807
  admincount      : 1
  adspath         : LDAP://CN=Jane Doe,OU=Users,DC=corp,DC=local
  badpasswordtime : 132283539768796534
  badpwdcount     : 1
  cn              : Jane Doe
  name            : Jane Doe
  samaccountname  : jd001

.EXAMPLE
  PS> Get-ADSIADUser -SamAccountName "jd001"

  accountexpires  : 9223372086854775807
  admincount      : 1
  adspath         : LDAP://CN=Jane Doe,OU=Users,DC=corp,DC=local
  badpasswordtime : 132283539768796534
  badpwdcount     : 1
  cn              : Jane Doe
  name            : Jane Doe
  samaccountname  : jd001


.EXAMPLE
  PS> Get-ADSIADUser -SamAccountName "jd001" -Membership

  Name     SamAccountName GroupName                                                
  ----     -------        ---------                                                
  Jane Doe jd001          App_AdobeWriter_5
  Jane Doe jd001          Remote Desktop users

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
    $SamAccountName,
    [Parameter(Mandatory=$false)]
    #Display group name membership only. 
    [Switch]
    $Membership=$false
)

    Begin
    {
    }
    Process
    {
        
        if ($PSCmdlet.ParameterSetName -eq "SAM")
        {
            $searchResult = foreach ($itemName in $SamAccountName)
            {
                ([adsisearcher]"(&(objectClass=user)(samaccountname=*$itemName*))").FindAll()
            }
        }

        if ($PSCmdlet.ParameterSetName -eq "Name")
        {
            $searchResult = foreach ($itemName in $Name)
            {
                ([adsisearcher]"(&(objectClass=user)(name=*$itemName*))").FindAll()
            }
        }

        if($Membership)
        {
            Write-Verbose "[INFO] Returning membership only"
            foreach ($item in $searchResult)
            {
                foreach ($group in $searchResult.Properties.memberof | sort)
                {
                    $hash = [ordered]@{}
                    $hash.Name = $item.Properties | % { $_.name }
                    $hash.SamAccountName = $item.Properties | % { $_.samaccountname }
                    $hash.GroupName = $group.Substring(3,$group.IndexOf(",")-3)
                    $object = New-Object -TypeName PSObject -Property $hash
                    $object
                }#end foreach group
            }
        } else {
            Write-Verbose "[INFO] Returning result as powershell object"
            #create a custom object
            foreach ($item in $searchResult)
            {
                $hash = [ordered]@{}
                foreach ($keyName in $item.Properties.Keys | Sort)
                {
                    $hash.$($keyName) = $item.Properties | % { $_.$keyName }
                }
                $object = New-Object -TypeName PSObject -Property $hash
                $object
            }
        }
    }
    End
    {
    }
}
