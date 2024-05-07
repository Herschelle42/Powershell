function Get-Uptime {
<#
.SYNOPSIS
  Get the uptime of the current machine
.NOTES
  Author: Clint Fritz
#>
    $lastBootTime = (get-date) - (Get-CimInstance -ClassName Win32_OperatingSystem).lastbootuptime

    return "Uptime: $($lastBootTime.Days) Days $($lastBootTime.Hours) Hours $($lastBootTime.Minutes) Minutes"
}
