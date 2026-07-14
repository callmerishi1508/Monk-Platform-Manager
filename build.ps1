$ErrorActionPreference = "Stop"

$buildStart = Get-Date
$buildLog = $null
$buildSucceeded = $false

try {

    #-------------------------------------------------------
    # Start Build Logging
    #-------------------------------------------------------

    $buildLog = Start-MonkReleaseLog

    Write-Host ""
    Write-Host "================================================="
    Write-Host "         MONK PLATFORM BUILD SYSTEM"
    Write-Host "================================================="
    Write-Host ""

    #-------------------------------------------------------
    # Version Information
    #-------------------------------------------------------

    $version = Get-MonkVersionInfo

    $versionString = "{0}.{1}.{2}" -f `
        $version.Major,
        $version.Minor,
        $version.Patch

    #-------------------------------------------------------
    # Git Information
    #-------------------------------------------------------

    $git = Get-MonkGitInfo

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
        -Recurse |
        Out-Null

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
    # Package Information
    #-------------------------------------------------------

    $zip = Join-Path `
        "$PSScriptRoot\release" `
        ("Monk.Platform-{0}.zip" -f $versionString)

    $packageSize = "Unknown"

    if (Test-Path $zip) {

        $packageSize = "{0:N2} MB" -f (
            (Get-Item $zip).Length / 1MB
        )

    }

    #-------------------------------------------------------
    # Summary
    #-------------------------------------------------------

    $elapsed = (Get-Date) - $buildStart

    Write-Host ""
    Write-Host "================================================="
    Write-Host "                BUILD SUMMARY"
    Write-Host "================================================="
    Write-Host ""

    Write-Host ("Version      : {0}" -f $versionString)
    Write-Host ("Build        : {0}" -f $version.Build)
    Write-Host ("Branch       : {0}" -f $git.Branch)
    Write-Host ("Commit       : {0}" -f $git.Commit)
    Write-Host ("PowerShell   : {0}" -f $PSVersionTable.PSVersion)
    Write-Host ("Platform     : {0}" -f [System.Environment]::OSVersion.VersionString)

    Write-Host ""

    Write-Host ("Package      : Monk.Platform-{0}.zip" -f $versionString)
    Write-Host ("Package Size : {0}" -f $packageSize)

    Write-Host ""

    Write-Host ("Build Time   : {0:N2} sec" -f $elapsed.TotalSeconds)

    if ($buildLog) {

        Write-Host ""
        Write-Host ("Build Log    : {0}" -f $buildLog)

    }

    Write-Host ""
    Write-Host "BUILD SUCCESSFUL" -ForegroundColor Green
    Write-Host "================================================="

    $buildSucceeded = $true

}
catch {

    Write-Host ""
    Write-Host "========== BUILD FAILED ==========" -ForegroundColor Red

    Write-Host "Message:" -ForegroundColor Yellow
    Write-Host $_.Exception.Message

    Write-Host ""
    Write-Host "Exception Type:" -ForegroundColor Yellow
    Write-Host $_.Exception.GetType().FullName

    Write-Host ""
    Write-Host "Invocation:" -ForegroundColor Yellow
    $_.InvocationInfo.PositionMessage

    Write-Host ""
    Write-Host "Stack:" -ForegroundColor Yellow
    Write-Host $_.ScriptStackTrace

    throw

}
finally {

    if ($buildLog) {

        try {

            Stop-MonkReleaseLog | Out-Null

        }
        catch {
        }

    }

    if ($buildSucceeded) {

        Exit-MonkSuccess

    }
    else {

        throw "Build failed."

    }

}