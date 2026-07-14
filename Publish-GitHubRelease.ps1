$ErrorActionPreference = "Stop"

$releaseLog = $null
$releaseSucceeded = $false

try {

    #-------------------------------------------------------
    # Start Logging
    #-------------------------------------------------------

    $releaseLog = Start-MonkReleaseLog

    #-------------------------------------------------------
    # GitHub CLI
    #-------------------------------------------------------

    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        throw "GitHub CLI (gh) is not installed."
    }

    gh auth status *> $null

    if ($LASTEXITCODE -ne 0) {
        throw "GitHub CLI is not authenticated. Run: gh auth login"
    }

    #-------------------------------------------------------
    # Git Information
    #-------------------------------------------------------

    $git = Get-MonkGitInfo

    if (-not $git.IsGitRepo) {
        throw "Current directory is not inside a Git repository."
    }

    if ($git.Remote -eq "None") {
        throw "No Git remote named 'origin' found."
    }

    #-------------------------------------------------------
    # Version Information
    #-------------------------------------------------------

    $version = Get-MonkVersionInfo

    $versionString = "{0}.{1}.{2}" -f `
        $version.Major,
        $version.Minor,
        $version.Patch

    $tag = "v$versionString"

    #-------------------------------------------------------
    # Release Assets
    #-------------------------------------------------------

    $zip = Join-Path `
        ".\release" `
        ("Monk.Platform-{0}.zip" -f $versionString)

    $notes = Join-Path `
        ".\release" `
        ("Monk.Platform-{0}\RELEASE_NOTES.md" -f $versionString)

    if (!(Test-Path $zip)) {
        throw "Package not found: $zip"
    }

    if (!(Test-Path $notes)) {
        throw "Release notes not found: $notes"
    }

    #-------------------------------------------------------
    # Publish
    #-------------------------------------------------------

    Write-Host ""
    Write-Host "========================================"
    Write-Host "          GITHUB RELEASE"
    Write-Host "========================================"
    Write-Host ""

    gh release create `
        $tag `
        $zip `
        --title "Monk Platform $versionString" `
        --notes-file $notes

    if ($LASTEXITCODE -ne 0) {
        throw "GitHub release creation failed."
    }

    Write-Host ""
    Write-Host "✓ GitHub Release published." -ForegroundColor Green

    Write-Host ""

    gh release view `
        $tag `
        --json url `
        --jq ".url"

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

        Exit-MonkFailure "GitHub Release failed."

    }

}