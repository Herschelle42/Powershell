<#
.SYNOPSIS
  Example of using try\catch block
#>

try {
    $workflow = Invoke-RestMethod -Method $method -Uri $uri -Headers $headers -SkipCertificateCheck:$SkipCertificateCheck -ErrorVariable UpdateError
} catch [Microsoft.PowerShell.Commands.HttpResponseException] {
    if ($_.ErrorDetails.Message -match "Workflow with id $($newSub.runnableId) not found on integration") {
        Write-Warning "No Workflow found with id: $($newSub.runnableId)"
        Continue
    } else {
        Write-Output "Error Exception Type:   [$($_.exception.gettype().fullname)]"
        Write-Output "Error Message:          $($_.ErrorDetails.Message)"
        Write-Output "Exception Message:      $($_.Exception.Message)"
        Write-Output "StatusCode:             $($_.Exception.Response.StatusCode.value__)"
        Continue
    }
} catch {
    Write-Output "Error Exception Type:   [$($_.exception.gettype().fullname)]"
    Write-Output "Error Message:          $($_.ErrorDetails.Message)"
    Write-Output "Exception Message:      $($_.Exception.Message)"
    Write-Output "StatusCode:             $($_.Exception.Response.StatusCode.value__)"
    Continue
}
Write-Verbose "workflow found." -Verbose
