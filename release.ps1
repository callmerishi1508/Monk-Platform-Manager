[CmdletBinding()]
param(
    [switch]$PublishGitHub,
    [switch]$IncrementPatch
)

$ErrorActionPreference = "Stop"

$releaseStart = Get-Date
$releaseLog = $null
$releaseSucceeded = $false

try {

    #-------------------------------------------------------
    # Start Release Logging
    #-------------------------------------------------------

    $releaseLog = Start-MonkReleaseLog

    Write-Host ""
    Write-Host "================================================="
    Write-Host "        MONK PLATFORM RELEASE PIPELINE"
    Write-Host "================================================="
    Write-Host ""

    #-------------------------------------------------------
    # Optional Version Increment
    #-------------------------------------------------------

    if ($IncrementPatch) {

        Write-Host "[0/6] Increment Version"

        Increment-MonkVersion Patch

        Write-Host ""

    }

    #-------------------------------------------------------
    # Validate
    #-------------------------------------------------------

    Write-Host "[1/6] Validate Release"

    & "$PSScriptRoot\Validate-Release.ps1"

    #-------------------------------------------------------
    # Build
    #-------------------------------------------------------

    Write-Host ""
    Write-Host "[2/6] Build"

    & "$PSScriptRoot\build.ps1"

    #-------------------------------------------------------
    # Release Notes
    #-------------------------------------------------------

    Write-Host ""
    Write-Host "[3/6] Release Notes"

    & "$PSScriptRoot\Generate-ReleaseNotes.ps1"

    #-------------------------------------------------------
    # Git Tag
    #-------------------------------------------------------

    Write-Host ""
    Write-Host "[4/6] Git Tag"

    & "$PSScriptRoot\Tag-Release.ps1"

    #-------------------------------------------------------
    # GitHub Release
    #-------------------------------------------------------

    if ($PublishGitHub) {

        Write-Host ""
        Write-Host "[5/6] GitHub Release"

        & "$PSScriptRoot\Publish-GitHubRelease.ps1"

    }
    else {

        Write-Host ""
        Write-Host "[5/6] GitHub Release (Skipped)"

    }

    #-------------------------------------------------------
    # Summary
    #-------------------------------------------------------

    $elapsed = (Get-Date) - $releaseStart

    Write-Host ""
    Write-Host "================================================="
    Write-Host "              RELEASE SUMMARY"
    Write-Host "================================================="
    Write-Host ""

    Write-Host ("Completed : {0}" -f (Get-Date))
    Write-Host ("Duration  : {0:N2} sec" -f $elapsed.TotalSeconds)

    Write-Host ""

    if ($PublishGitHub) {
        Write-Host "GitHub Release : Published"
    }
    else {
        Write-Host "GitHub Release : Skipped"
    }

    if ($releaseLog) {
        Write-Host ""
        Write-Host "Release Log : $releaseLog"
    }

    Write-Host ""
    Write-Host "RELEASE COMPLETED" -ForegroundColor Green
    Write-Host "================================================="

    $releaseSucceeded = $true

}
catch {

    Write-MonkError $_.Exception.Message

}
finally {

    if ($releaseLog) {

        try {

            Stop-MonkReleaseLog | Out-Null

        }
        catch {
        }

    }

    if ($releaseSucceeded) {

        Exit-MonkSuccess

    }
    else {

        Exit-MonkFailure "Release pipeline failed."

    }

}