# Set the minimum file size to 5MB
$minSizeMB = 5
$minSizeBytes = $minSizeMB * 1MB

# Get all files larger than the minimum size, excluding .git and node_modules
$largeFiles = Get-ChildItem -Path . -Recurse -File -ErrorAction SilentlyContinue | 
    Where-Object { $_.Length -gt $minSizeBytes -and 
                 $_.FullName -notmatch '\\.git\\.*' -and 
                 $_.FullName -notmatch '\\node_modules\\.*' } | 
    Select-Object FullName, 
        @{Name="SizeMB"; Expression={"{0:N2}" -f ($_.Length / 1MB)}} |
    Sort-Object { [double]($_.SizeMB -replace '[^0-9.]') } -Descending

# Display the results
if ($largeFiles) {
    Write-Host "`nFound the following files larger than $minSizeMB MB:`n"
    $largeFiles | Format-Table -AutoSize
    
    # Save to a text file with full paths
    $outputFile = "large-files-details.txt"
    $largeFiles | Format-Table -AutoSize | Out-String -Width 4096 | Out-File -FilePath $outputFile -Encoding UTF8
    
    Write-Host "`nDetailed list saved to: $outputFile"
    
    # Show summary
    $totalSizeMB = ($largeFiles | Measure-Object -Property { [double]($_.SizeMB) } -Sum).Sum
    Write-Host "`nTotal size of large files: {0:N2} MB" -f $totalSizeMB
    Write-Host "Number of large files found: $($largeFiles.Count)"
} else {
    Write-Host "No files larger than $minSizeMB MB found."
}

# Also check .git directory size
$gitDir = ".\.git"
if (Test-Path $gitDir) {
    $gitSize = (Get-ChildItem -Path $gitDir -Recurse -File -ErrorAction SilentlyContinue | 
               Measure-Object -Property Length -Sum).Sum
    $gitSizeMB = [math]::Round($gitSize / 1MB, 2)
    Write-Host "`nSize of .git directory: $gitSizeMB MB"
}

Write-Host "`nDone. Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
