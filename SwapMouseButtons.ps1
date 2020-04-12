<#
.Synopsis
  Swaps mouse buttons from Left to Right and visa versa
.Description
  If, like me, you use the mouse left handed going through the GUI is a pain to swap the buttons over. Swapping between an external mouse when at work and the touchpad when on the road means I keep changing back and forth. So this little script allows me to fix that in a second.
.Notes
  Author:  Clint Fritz
  Create a shortcut powershell.exe -NoProfile -File SwapMouseButtons.ps1
  Downloaded 2015-03-17 from: http://superuser.com/questions/51240/powershell-or-other-script-to-swap-mouse-buttons
#>
[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
$SwapButtons = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
public static extern bool SwapMouseButton(bool swap);
'@ -Name "NativeMethods" -Namespace "PInvoke" -PassThru
[bool]$returnValue = $SwapButtons::SwapMouseButton(!([System.Windows.Forms.SystemInformation]::MouseButtonsSwapped))
