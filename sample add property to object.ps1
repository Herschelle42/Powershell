#Add a Property to an object, if it does not already exist
if (-not [bool]($myObject.PSObject.Properties.Name -match "myProperty")) {
    $myObject | Add-Member -MemberType NoteProperty -Name "myProperty" -Value $null
}
