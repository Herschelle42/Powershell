#test version of powershell. PS 1 and 2 do not support ordered hash tables.
if ($PSVersionTable.PSVersion.Major -gt 2)
{
    $hash = [ordered]@{}
} else {
    $hash = @{}
} #end if psversion

$hash.Name = $accred.Name
$hash.Accreditation = $accred.Accreditation
$hash.Expires = [DateTime]::Parse($accred.expires) | Get-Date -Format "dd/MM/yyyy"
$object = new-object PSObject -property $hash

#test version of powershell. PS 1 and 2 do not support ordered hash tables.
if ($PSVersionTable.PSVersion.Major -gt 2)
{
    $object
} else {
    $object | Select Name, Accreditation, Expires
} #end if psversion
