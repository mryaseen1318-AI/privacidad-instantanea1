# Cleanup Script for Privacidad Instantánea Project

# Directories to remove
$directoriesToRemove = @(
    "node_modules",
    "dist",
    "build",
    "out",
    "release",
    "privacidad-instantanea\node_modules",
    "privacidad-instantanea\dist",
    "privacidad-instantanea\build",
    "privacidad-instantanea\out",
    "privacidad-instantanea\release",
    ".cache",
    ".temp",
    ".tmp"
)

# File patterns to remove
$filePatternsToRemove = @(
    "*.exe",
    "*.dmg",
    "*.AppImage",
    "*.deb",
    "*.rpm",
    "*.snap",
    "*.zip",
    "*.7z",
    "*.msi",
    "*.pkg",
    "*.log",
    "*.log.*",
    "npm-debug.log*",
    "yarn-debug.log*",
    "yarn-error.log*"
)

Write-Host "Starting cleanup..." -ForegroundColor Green

# Remove directories
foreach ($dir in $directoriesToRemove) {
    $fullPath = Join-Path -Path $PSScriptRoot -ChildPath $dir
    if (Test-Path $fullPath) {
        try {
            Remove-Item -Path $fullPath -Recurse -Force -ErrorAction Stop
            Write-Host "Removed directory: $dir" -ForegroundColor Yellow
        } catch {
            Write-Host "Failed to remove directory: $dir" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
    } else {
        Write-Host "Directory not found: $dir" -ForegroundColor Gray
    }
}

# Remove files by pattern
foreach ($pattern in $filePatternsToRemove) {
    try {
        $files = Get-ChildItem -Path $PSScriptRoot -Include $pattern -Recurse -File -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            try {
                Remove-Item -Path $file.FullName -Force -ErrorAction Stop
                Write-Host "Removed file: $($file.FullName)" -ForegroundColor Yellow
            } catch {
                Write-Host "Failed to remove file: $($file.FullName)" -ForegroundColor Red
                Write-Host $_.Exception.Message -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "Error processing pattern: $pattern" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

# Clean up empty directories
Get-ChildItem -Path $PSScriptRoot -Directory -Recurse -Force | 
    Where-Object { $_.GetFiles().Count -eq 0 -and $_.GetDirectories().Count -eq 0 } | 
    ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Force -ErrorAction Stop
            Write-Host "Removed empty directory: $($_.FullName)" -ForegroundColor DarkGray
        } catch {
            Write-Host "Failed to remove empty directory: $($_.FullName)" -ForegroundColor Red
        }
    }

Write-Host "`nCleanup completed!" -ForegroundColor Green
Write-Host "You can now try pushing to GitHub again." -ForegroundColor Green
Write-Host "If you still have issues, you may need to create a new repository with only the necessary files." -ForegroundColor Yellow
