$ErrorActionPreference = "Stop"

$notesLog = $null
$notesSucceeded = $false

try {

    #-------------------------------------------------------
    # Start Logging
    #-------------------------------------------------------

    $notesLog = Start-MonkReleaseLog

    Write-Host ""
    Write-Host "========================================"
    Write-Host "      GENERATE RELEASE NOTES"
    Write-Host "========================================"
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

    if (-not $git.IsGitRepo) {
        throw "Current directory is not inside a Git repository."
    }

    #-------------------------------------------------------
    # Release Folder
    #-------------------------------------------------------

    $releaseFolder = Join-Path `
        ".\release" `
        ("Monk.Platform-{0}" -f $versionString)

    if (!(Test-Path $releaseFolder)) {
        throw "Release folder not found: $releaseFolder"
    }

    #-------------------------------------------------------
    # Release Notes File
    #-------------------------------------------------------

    $notes = Join-Path `
        $releaseFolder `
        "RELEASE_NOTES.md"

    #-------------------------------------------------------
    # Collect Commits
    #-------------------------------------------------------

    $commits = git log `
        --pretty=format:"- %s" `
        -20

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to retrieve Git commit history."
    }

    #-------------------------------------------------------
    # Generate Notes
    #-------------------------------------------------------

@"
# Monk Platform v$versionString

Release Date: $(Get-Date -Format "yyyy-MM-dd")

## Changes

$commits

---

Generated automatically by Monk Platform.
"@ | Set-Content $notes

    Write-Host ""
    Write-Host "✓ Release notes generated." -ForegroundColor Green
    Write-Host "File : $notes"

    $notesSucceeded = $true

}
catch {

    Write-MonkError $_.Exception.Message

}
finally {

    if ($notesLog) {

        try {

            Stop-MonkReleaseLog | Out-Null

        }
        catch {
        }

    }

    if ($notesSucceeded) {

        Exit-MonkSuccess

    }
    else {

        Exit-MonkFailure "Release notes generation failed."

    }

}