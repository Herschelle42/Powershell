function Restart-Citrix {
    Stop-Citrix
    Start-Process -FilePath "C:\Program Files (x86)\Citrix\ICA Client\SelfServicePlugin\SelfService.exe"
}
