function Import-PSCredentialFiles {
    Param (
        $Path = "$($env:USERPROFILE)\Documents\Scripts",
        #Get-ChildItem filter syntax.
        [string]$Filter = "cred*.xml"
    )
    Begin {
        if(-not (Get-Command -Name Import-PSCredential -ErrorAction SilentlyContinue)) {
            throw "Import-PSCredential is required for this function to operate."
        }
    }
    Process {
        $fileList = @()
        $fileList = Get-ChildItem -Path $path -Filter $Filter
        if($fileList.Count -gt 0 ) {
            foreach ($file in $fileList) {
                $varName = ($file.name.substring(0,($file.name.IndexOf("."))))
                New-Variable -Name $varName -Scope Global -Value (Import-PSCredential -Path $file.FullName) -Force
                Write-Output $varName
            }
        } else {
            Write-Warning "No files found. $($Path)\$($Filter)"
        }
    }
}
