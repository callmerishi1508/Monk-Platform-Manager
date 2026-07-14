$ErrorActionPreference = "Stop"

$buildStart = Get-Date

Write-Host ""
Write-Host "================================================="
Write-Host "         MONK PLATFORM BUILD SYSTEM"
Write-Host "================================================="
Write-Host ""

#-------------------------------------------------------
# Read Version
#-------------------------------------------------------

$version = Get-Content "$PSScriptRoot\version.json" |
    ConvertFrom-Json

$versionString = "{0}.{1}.{2}" -f `
    $version.Major,
    $version.Minor,
    $version.Patch

#-------------------------------------------------------
# Clean
#-------------------------------------------------------

Write-Host "[1/5] Clean"

& "$PSScriptRoot\clean.ps1"

#-------------------------------------------------------
# Manifest
#-------------------------------------------------------

Write-Host ""
Write-Host "[2/5] Validate Manifest"

Test-ModuleManifest `
    "$PSScriptRoot\modules\Monk.Platform\Monk.Platform.psd1" |
Out-Null

Write-Host "✓ Manifest"

#-------------------------------------------------------
# Script Analyzer
#-------------------------------------------------------

Write-Host ""
Write-Host "[3/5] Script Analyzer"

Invoke-ScriptAnalyzer `
    -Path "$PSScriptRoot\modules" `
    -Recurse | Out-Null

Write-Host "✓ Analyzer"

#-------------------------------------------------------
# Tests
#-------------------------------------------------------

Write-Host ""
Write-Host "[4/5] Tests"

& "$PSScriptRoot\tests\Run-Tests.ps1"

Write-Host "✓ Tests"

#-------------------------------------------------------
# Package
#-------------------------------------------------------

Write-Host ""
Write-Host "[5/5] Package"

& "$PSScriptRoot\package.ps1"

Write-Host "✓ Package"

#-------------------------------------------------------
# Build Summary
#-------------------------------------------------------

$gitCommit = git rev-parse --short HEAD 2>$null

if (-not $gitCommit) {
    $gitCommit = "Unknown"
}

$gitBranch = git branch --show-current 2>$null

if (-not $gitBranch) {
    $gitBranch = "Unknown"
}

$zip = Join-Path `
    "$PSScriptRoot\release" `
    ("Monk.Platform-{0}.zip" -f $versionString)

$packageSize = "Unknown"

if(Test-Path $zip){

    $packageSize = "{0:N2} MB" -f (
        (Get-Item $zip).Length / 1MB
    )

}

$elapsed = (Get-Date) - $buildStart

Write-Host ""
Write-Host "================================================="
Write-Host "                BUILD SUMMARY"
Write-Host "================================================="
Write-Host ""

Write-Host ("Version      : {0}" -f $versionString)
Write-Host ("Build        : {0}" -f $version.Build)
Write-Host ("Branch       : {0}" -f $gitBranch)
Write-Host ("Commit       : {0}" -f $gitCommit)
Write-Host ("PowerShell   : {0}" -f $PSVersionTable.PSVersion)
Write-Host ("Platform     : {0}" -f [System.Environment]::OSVersion.VersionString)

Write-Host ""

Write-Host ("Package      : Monk.Platform-{0}.zip" -f $versionString)
Write-Host ("Package Size : {0}" -f $packageSize)

Write-Host ""

Write-Host ("Build Time   : {0:N2} sec" -f $elapsed.TotalSeconds)

Write-Host ""
Write-Host "BUILD SUCCESSFUL" -ForegroundColor Green
Write-Host "================================================="
