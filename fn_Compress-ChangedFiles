function Compress-ChangedFiles {
<#
.SYNOPSIS
  Zips changed files from a given directory location.
.DESCRIPTION
  Given a directory location and number of days collect all the files that have 
  been changed in the last x days, copies these files to a temporary loccation,
  zips the temporay location, deletes the temporary location and optionally 
  launches the resulting zip file.
.INPUTS
  [string]
.OUTPUTS
  ZipFile
.PARAMETER Path
  The directory path to search. Default is %USERPROFILE%. C:\users\username
.PARAMETER Days
  How recently the files have been updated to search for. To find all files 
  changed in the last seven (7) days set to 7. Default is 30.
.PARAMETER ZipPath
  The full path and name of the Zip file to be created. If ZipPath is not 
  specified function will only report to screen
.PARAMETER ExcludeDirectory
  Directories to exclude using regex OR.
  Example: -ExcludeDirectoryRegex "vroclient|Modules"
  Where we are excluding any directory that matches vroclient or Modules
.PARAMETER TempDir
  The temporary directory location where a copy of the changed files will be
  copied so that the zip can be created. Default is: ENV:temp\<random name 2>
.PARAMETER Overwrite
  Switch to determine whether to overwrite the target Zip file, if it already
  exists. Default is false.
.PARAMETER Launch
  Switch to determine whether to lauch (open) the newly created Zip file upon
  completion. Default is false.
.EXAMPLE
  $ISODateTime = Get-Date -UFormat "%Y-%m-%d-%H-%M-%S"
  Compress-ChangedFiles -Path "$($env:USERPROFILE)\Documents\Scripts" -Days 7 -ZipPath "$($env:USERPROFILE)\Documents\Scripts-$($ISODateTime).zip"
.NOTES
  Author: Clint Fritz
  Version: 0.3
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)]
    [ValidateScript({if (Test-Path -Path $_) { $true } else { throw "Invalid path $_" } })]
    [String]$Path=$env:USERPROFILE,
    [Parameter(Mandatory=$false)]
    [Int]$Days=30,
    [Parameter(Mandatory=$false)]
    [String]$ZipPath,
    [Parameter(Mandatory=$false)]
    [String[]]$ExcludeDirectory,
    [Parameter(Mandatory=$false)]
    [Switch]$Overwrite=$false,
    [Parameter(Mandatory=$false)]
    [Switch]$Launch=$false,
    [Parameter(Mandatory=$false)]
    [String]$TempDir="$env:temp\$(([System.IO.Path]::GetRandomFileName()).Split(‘.’)[0])"

)#end Param block

    Begin {
        #Trim any trailing backslash or forward slash. You never know.
        $Path = $Path.Trim("\").Trim("/")

        Write-Verbose "[INFO] PARAMETER Path       : $($Path)"
        Write-Verbose "[INFO] PARAMETER Days       : $($Days)"
        Write-Verbose "[INFO] PARAMETER ZipPath    : $($ZipPath)"
        Write-Verbose "[INFO] PARAMETER TempDir    : $($TempDir)"

        $sizeKB = @{name="SizeKB"; Expression ={[Math]::Ceiling($_.Length/1KB)}}
        $sizeMB = @{name="SizeMB"; Expression ={[Math]::Ceiling($_.Length/1MB)}}

        $ISODate = Get-Date -uFormat "%Y-%m-%d"
        $ISODateTime = Get-Date -uFormat "%Y-%m-%d-%H-%M-%S"

        #Convert $ExcludeDirectory -join "|"
        $ExcludeDirectoryRegex = $ExcludeDirectory -join "|"

        #Test if ZipPath already exists and the Overwrite parameter
        if((Test-Path -Path $ZipPath) -and -not $Overwrite)
        {
            throw "The Zip file: $($ZipPath) already exists. Terminating."
        }

        #Delete ZipFile if it already exists and user and selected to OverWrite the file
        if((Test-Path -Path $ZipPath) -and $Overwrite)
        {
            Write-Verbose "[INFO] Deleting existing zip file: $($ZipPath)"
            Remove-Item -Path $ZipPath -Confirm:$false
        }#end if testpath and overwrite

        function Compress-Directory($Path, $Source)
        {
           Add-Type -Assembly System.IO.Compression.FileSystem
           $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
           [System.IO.Compression.ZipFile]::CreateFromDirectory($Source, $Path, $compressionLevel, $false)
        }

    }#end begin block

    Process {

        #Check if directories are being excluded
        if ($ExcludeDirectoryRegex)
        {
            $filelist = Get-ChildItem -Path $path -Recurse -File | ? { $_.LastWriteTime -gt (Get-Date).AddDays(-$days) -and $_.Directory -notmatch $ExcludeDirectoryRegex }
        } else {
            $filelist = Get-ChildItem -Path $path -Recurse -File | ? { $_.LastWriteTime -gt (Get-Date).AddDays(-$days) }
        }#end if exDirRegex

        $totalSizeMB = [math]::Ceiling($(($filelist | Measure-Object -Property Length -Sum).Sum/1MB))

        Write-Verbose "Last $($days) days of file changes."
        Write-Verbose "Number of files: $($filelist.Count)"
        Write-Verbose "Total Size (MB): $($totalSizeMB)"

        Write-Verbose "The 5 largest files are: "
        $filelist | Sort Length -Descending | Select $sizeMB, Name, Directory | Select -First 5 | ft -AutoSize

        if ($ZipPath)
        {
            Write-Verbose "[INFO] Create Temp Dir : $($tempDir)"
            New-Item -Path $tempDir -ItemType Directory | Out-Null

            Write-Verbose "[INFO] Copy changed files to temporary directory"
            foreach ($file in $filelist) {
                Write-Output "[INFO] Copying: $($file.Name)"
                Write-Debug "File Directory Name: $($file.DirectoryName)"
                #Create the same directory structure in the temporary directory
                $tempDest = New-Item -Path ($file.DirectoryName -replace [Regex]::Escape($path), [Regex]::Escape($tempDir)) -ItemType Directory -Force
                Write-Debug "[DEBUG] tempDest: $($tempDest)"
                #Copy the file to the temporary directory
                Copy-Item -Path $file.FullName -Destination $tempDest -Force
            }#end foreach file

            Write-Verbose "[INFO] Zip files and folders in the temporary directory."
            Compress-Directory -Path $ZipPath -Source $tempDir

            if(-not (Test-Path -Path $ZipPath))
            {
                Write-Warning "[WARN] ZipPath: $($ZipPath) not found"
            }#end if test zippath

            #Launch (open) the resulting zip file if requested.
            if($Launch)
            {
                Invoke-Item -Path $ZipPath
            }#end if Launch

            Write-Verbose "[INFO] Delete temporary directory"
            if (Test-Path -Path $tempDir)
            {
                Remove-Item -Path $tempDir -Recurse -Force
            }#end if
        } else {
            Write-output "No ZipPath specified, therefore no Zip file created."
        }#end if zippath

    }#end process block

}#end function
