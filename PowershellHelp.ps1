<#
.Synopsis
  Save Powershell Help locally for offline installation
.Notes
  Author:  Clint Fritz
  Requires Admin access to update Powershell help
#>

#Set the location destination to save Powershell Help files to
$pshelpsource = 'C:\Data\PowershellHelp'
if (-not (Test-Path -Path $pshelpsource))
{
  New-Item -ItemType Directory -Path $pshelpsource
} #end if pshelpsource

#Download and Save Powershell Help
Write-Output "Saving PowerShell help to: $($pshelpsource)"
Save-Help -DestinationPath $pshelpsource

#add test for Admin privileges

#Install Powershell help files previously download
Write-Output "Updating Powershell Help from local source: $($pshelpsource)"
Update-Help -SourcePath $pshelpsource
