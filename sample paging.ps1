
$pageSize = 20
$pageCount = 1
$startItem = 0

if($list.Count -gt $pageSize) {
    $endItem = $pageSize-1
} else {
    $endItem = $list.Count
}
$pageTotal = [Math]::Ceiling($list.Count / $pageSize)


Write-Verbose "$(Get-Date) Total items to process: $($list.Count)"


while ($pageCount -le $pageTotal) {
    Write-Verbose "$(Get-Date) Processing Page: $($pageCount) of $($pageTotal) - $($startItem)..$($endItem)"


    #Do processing here - $list[$startItem..$endItem]




        
    #increment
    $pageCount++
    $startItem = $startItem + $pageSize
    $endItem = $endItem + $pageSize
    if($endItem -gt $list.Count) {
        $endItem = $list.Count-1
    }
}

