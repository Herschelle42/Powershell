function Get-ADSIADUser
{
<#
.SYNOPSIS
   Get AD User object using ADSI
.DESCRIPTION
   Not all servers and workstations have RSAT installed. This is a small function 
   using ADSI to get a user details via Name or SamAccountName.
   Only searches the current Domain this powershell session is a part of.
.INPUTS
  [String[]]
.PARAMETER ShowAllProperties
  This is a workaround, due to security restrictions onsite, that prevents the Update-DataType
  
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
                ValueFromPipeline,
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
    [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            ParameterSetName="SID",
            Position=0)]
    [String[]]
    $SID,
    [Parameter(Mandatory=$false,
                ParameterSetName='Name')]
    [Parameter(Mandatory=$false,
                ParameterSetName='SAM')]
    [Parameter(Mandatory=$false,
                ParameterSetName='Showall')]
    [Switch]
    $ShowAllProperties=$false,
    #Display group name membership only. 
    [Parameter(Mandatory=$false,
                ParameterSetName='Name')]
    [Parameter(Mandatory=$false,
                ParameterSetName='SAM')]
    [Parameter(Mandatory=$false,
                ParameterSetName='Membership')]
    [Switch]
    $Membership=$false
)

    Begin
    {
        #Used for the ShowAllProperties parameter
        $DefaultDisplaySet = ('name',
            'samaccountname',
            'userprincipalname',
            'distinguishedname',
            @{Name="Lockout Time"; Expression={if($_.lockouttime -gt 0) {[datetime]::FromFileTime($_.lockouttime)} else {"0"} }},
            @{Name="Last Logon"; Expression={[datetime]::FromFileTime($_.lastlogon)}},
            @{Name="Account Expires"; Expression={[datetime]::FromFileTime($_.accountexpires)}},
            @{Name="Bad Password Time"; Expression={[datetime]::FromFileTime($_.badpasswordtime)}},
            @{Name="Last Password Set"; Expression={[datetime]::FromFileTime($_.pwdlastset)}},
            'manager',
            'department'
        )

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

        if ($PSCmdlet.ParameterSetName -eq "SID")
        {
            $searchResult = foreach ($itemName in $SID)
            {
                Write-Verbose "[INFO] ItemName: $($itemName)"
                ([adsisearcher]"(&(objectclass=user)(objectSID=*$itemName*))").FindAll()
            }
        }

        if($Membership)
        {
            Write-Verbose "[INFO] Returning membership only"
            foreach ($item in $searchResult)
            {
                foreach ($group in $item.Properties.memberof | sort)
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
                $hash.PSTypeName = "User.Information"
                foreach ($keyName in $item.Properties.Keys | Sort)
                {
                    $hash.$($keyName) = $item.Properties | % { $_.$keyName }

                    #Convert the ObjectSID byte object to proper SID String value
                    if($keyName -eq "objectsid") {
                        $hash.objectsidstring = (New-Object System.Security.Principal.SecurityIdentifier($hash.objectsid,0)).Value
                    }

                    #Convert the ObjectSID byte object to proper SID String value
                    if($keyName -eq "objectguid") {
                        $hash.objectguidstring = (New-Object -TypeName Guid -ArgumentList @(,$hash.objectguid)).guid
                    }
                    
                }


                $object = New-Object -TypeName PSObject -Property $hash
                if ($ShowAllProperties) {
                    $object
                } else {
                    Write-Verbose "[INFO] Return only a subset."
                    $object | Select $DefaultDisplaySet
                }
            }
            
        }
    }
    End
    {
    }
}
