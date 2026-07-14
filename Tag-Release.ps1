$ErrorActionPreference = "Stop"

$tagLog = $null
$tagSucceeded = $false

try {

    #-------------------------------------------------------
    # Start Logging
    #-------------------------------------------------------

    $tagLog = Start-MonkReleaseLog

    Write-Host ""
    Write-Host "========================================"
    Write-Host "          GIT RELEASE TAG"
    Write-Host "========================================"
    Write-Host ""

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

    $tag = "v{0}.{1}.{2}" -f `
        $version.Major,
        $version.Minor,
        $version.Patch

    #-------------------------------------------------------
    # Create Tag
    #-------------------------------------------------------

    if ($git.Tags -contains $tag) {

        Write-Host "✓ Tag already exists locally: $tag" -ForegroundColor Yellow

    }
    else {

        git tag $tag

        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create Git tag '$tag'."
        }

        Write-Host "✓ Created tag $tag" -ForegroundColor Green

    }

    #-------------------------------------------------------
    # Push Tag
    #-------------------------------------------------------

    git push origin $tag

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to push Git tag '$tag'."
    }

    Write-Host "✓ Tag pushed to origin" -ForegroundColor Green

    Write-Host ""
    Write-Host "Current Tags:"
    git tag

    $tagSucceeded = $true

}
catch {

    Write-MonkError $_.Exception.Message

}
finally {

    if ($tagLog) {

        try {
            Stop-MonkReleaseLog | Out-Null
        }
        catch {
        }

    }

    if ($tagSucceeded) {

        Exit-MonkSuccess

    }
    else {

        Exit-MonkFailure "Git tag creation failed."

    }

}