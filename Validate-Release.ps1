$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================"
Write-Host "        RELEASE VALIDATION"
Write-Host "========================================"
Write-Host ""

$checks = @()

function Add-Check {
    param(
        [string]$Name,
        [bool]$Passed
    )

    $script:checks += [PSCustomObject]@{
        Check = $Name
        Passed = $Passed
    }

    if ($Passed) {
        Write-Host "✓ $Name"
    }
    else {
        Write-Host "✗ $Name"
    }
}

Add-Check "version.json" (Test-Path ".\version.json")
Add-Check "Module Manifest" (Test-Path ".\modules\Monk.Platform\Monk.Platform.psd1")
Add-Check "Release Folder" (Test-Path ".\release")

try {
    git rev-parse --is-inside-work-tree *> $null
    Add-Check "Git Repository" $true
}
catch {
    Add-Check "Git Repository" $false
}

$failed = $checks | Where-Object Passed -eq $false

Write-Host ""

if ($failed) {

    Write-Host "RELEASE VALIDATION FAILED" -ForegroundColor Red
    exit 1

}

Write-Host "RELEASE VALIDATION PASSED" -ForegroundColor Green
