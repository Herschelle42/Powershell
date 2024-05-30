<#
.SYNOPSIS
  Prompt user to select a file using a file browser window
.NOTES
  Use the Filter to limit the visibility of files. 
  For example to filter to Word and Excel documents only.
  Filter = 'Documents (*.docx)|*.docx|SpreadSheet (*.xlsx)|*.xlsx'

  The filter is '<display>|<file filter>'
  
  Filter = 'CSV (*.csv)|*.blah'
  This would not be very helpful because the filter is actually *.blah you would only be displayed files with the .blah extension.
  
#>
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('MyDocuments') 
    Filter = 'CSV (*.csv)|*.csv'
}
$null = $FileBrowser.ShowDialog()

#The returned element(s) are in the $FileBrowser object
if($FileBrowser.FileNames.Count -eq 1) {
    $myFile = $FileBrowser.FileName
} else {
    Write-Warning "No file selected or multiple selected."
    Return
}

