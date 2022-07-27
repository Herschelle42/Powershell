function Test-FileHash
{
Param (
    [string[]]$Path,
    [string]$Algorithm="MD5"
)

Begin {

}

Process {
    foreach ($filePath in $Path) {
        if (Test-Path -Path $filePath) {
            $file = Get-ChildItem -Path $filePath

            $checksum = (Get-Content -Path "$($file.FullName).txt" | Select-String -Pattern $Algorithm).ToString().Split(":")[1].trim().ToUpper()
            Write-Verbose "$($Algorithm) Source Checksum: $($checksum)" -Verbose

            $filehash = Get-FileHash -Path $Path -Algorithm $Algorithm
            Write-Verbose "Filehash: $($filehash.Hash)" -Verbose

            if ($checksum = $filehash.Hash) {
                Return $true
            } else {
                Return $false
            }

        } else {
            Write-Warning "File not found: $($filePath)"
        }
    }
}


}
