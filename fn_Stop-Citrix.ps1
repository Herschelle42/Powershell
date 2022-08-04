function Stop-Citrix {
    Get-Process | ? { $_.Description -match "Citrix" } | Stop-Process
}
