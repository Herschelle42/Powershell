function Get-DateFromUNIXTime {
<#
.SYNOPSIS
  Convert unix epoch time of seconds or milliseconds to a date object.
.EXAMPLE
  Get-DateFromUNIXTime -Milliseconds 1571702156379
.EXAMPLE
  Get-DateFromUNIXTime -Seconds 1568093872
#>

[CmdletBinding(DefaultParameterSetName="Milliseconds")]
Param (
    #Milliseconds from Epoch
    [Parameter(Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position=0,
            ParameterSetName="Milliseconds")]
    [System.Int64]$Milliseconds,
    #Seconds from Epoch
    [Parameter(Mandatory,
            ValueFromPipelineByPropertyName,
            Position=0,
            ParameterSetName="Seconds")]
    [System.Int64]$Seconds


)

Process {
    #$UnixTime.Gettype()
    if($Milliseconds) {
        (Get-Date 1970-01-01)+([System.TimeSpan]::FromMilliseconds($Milliseconds))
    }

    if($Seconds) {
        (Get-Date 1970-01-01)+([System.TimeSpan]::FromSeconds($Seconds))
    }
}

}
