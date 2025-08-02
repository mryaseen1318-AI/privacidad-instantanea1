# Find files larger than 5MB in the current directory and subdirectories
$largeFiles = Get-ChildItem -Path . -Recurse -File -ErrorAction SilentlyContinue | 
    Where-Object { $_.Length -gt 5MB } | 
    Select-Object FullName, 
        @{Name="SizeMB"; Expression={"{0:N2}" -f ($_.Length / 1MB)}}

# Display the results
if ($largeFiles) {
    Write-Host "Found the following large files:"
    $largeFiles | Format-Table -AutoSize
    
    # Save to a text file
    $largeFiles | Out-File -FilePath "large-files.txt" -Encoding UTF8
    Write-Host "List of large files saved to large-files.txt"
} else {
    Write-Host "No files larger than 5MB found."
}
