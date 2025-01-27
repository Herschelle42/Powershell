<#
.SYNOPSIS
  Convert Secure String to Plain Text for use in PSv5
.DESCRIPTION
  PS7 has ConvertFrom-SecureString -AsPlainText

  I do not remember where I found this code. Apologies to the original author.
#>
function ConvertFrom-SecureStringToPlainText ([System.Security.SecureString]$SecureString) {

    [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
    
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    )            
}
