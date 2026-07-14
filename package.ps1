$ErrorActionPreference = "Stop"

$packageLog = $null
$packageSucceeded = $false

try {

    #-------------------------------------------------------
    # Start Logging
    #-------------------------------------------------------

    $packageLog = Start-MonkReleaseLog

    Write-Host ""
    Write-Host "========================================"
    Write-Host "      MONK PLATFORM PACKAGER"
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

    #-------------------------------------------------------
    # Release Paths
    #-------------------------------------------------------

    $releaseRoot = Join-Path $PSScriptRoot "release"

    $packageRoot = Join-Path `
        $releaseRoot `
        "Monk.Platform-$versionString"

    if (Test-Path $packageRoot) {

        Remove-Item `
            -Path $packageRoot `
            -Recurse `
            -Force

    }

    New-Item `
        -ItemType Directory `
        -Force `
        -Path $packageRoot | Out-Null

    #-------------------------------------------------------
    # Copy Folders
    #-------------------------------------------------------

    $folders = @(
        "modules",
        "docs",
        "configs",
        "templates"
    )

    foreach ($folder in $folders) {

        if (Test-Path "$PSScriptRoot\$folder") {

            Copy-Item `
                "$PSScriptRoot\$folder" `
                $packageRoot `
                -Recurse `
                -Force

            Write-Host "✓ Copied $folder"

        }

    }

    #-------------------------------------------------------
    # Copy Documents
    #-------------------------------------------------------

    $documents = @(
        "README.md",
        "LICENSE",
        "CHANGELOG.md",
        "SECURITY.md",
        "CONTRIBUTING.md",
        "CODE_OF_CONDUCT.md"
    )

    foreach ($doc in $documents) {

        if (Test-Path "$PSScriptRoot\$doc") {

            Copy-Item `
                "$PSScriptRoot\$doc" `
                $packageRoot `
                -Force

            Write-Host "✓ Copied $doc"

        }

    }

    #-------------------------------------------------------
    # Build Information
    #-------------------------------------------------------

    $buildInfo = [ordered]@{

        Product           = "Monk Platform Manager"

        Version           = $versionString

        Build             = $version.Build

        BuildDate         = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

        GitCommit         = $git.Commit

        GitBranch         = $git.Branch

        GitRemote         = $git.Remote

        PowerShellVersion = $PSVersionTable.PSVersion.ToString()

        OS                = [System.Environment]::OSVersion.VersionString

        User              = $env:USERNAME

        Machine           = $env:COMPUTERNAME

    }

    $buildInfo |
        ConvertTo-Json -Depth 5 |
        Set-Content (Join-Path $packageRoot "BUILD_INFO.json")

    Write-Host "✓ BUILD_INFO.json generated"

    Write-Host ""
    Write-Host "Package created:"
    Write-Host $packageRoot

    #-------------------------------------------------------
    # Create ZIP Package
    #-------------------------------------------------------

    $zipFile = Join-Path `
        $releaseRoot `
        ("Monk.Platform-{0}.zip" -f $versionString)

    if (Test-Path $zipFile) {

        Remove-Item `
            -Path $zipFile `
            -Force

    }

    Compress-Archive `
        -Path "$packageRoot\*" `
        -DestinationPath $zipFile `
        -CompressionLevel Optimal

    Write-Host "✓ ZIP package created"

    Write-Host ""
    Write-Host "ZIP:"
    Write-Host $zipFile
    #-------------------------------------------------------
    # Verify Package Integrity
    #-------------------------------------------------------

    Write-Host ""
    Write-Host "Verifying package..."

    $requiredItems = @(
        "modules",
        "README.md"
    )

    foreach ($item in $requiredItems) {

        $path = Join-Path $packageRoot $item

        if (!(Test-Path $path)) {

            throw "Package validation failed. Missing: $item"

        }

        Write-Host "✓ $item"

    }

    Write-Host ""
    Write-Host "Package integrity verified."

    Write-Host ""
    Write-Host "========================================"
    Write-Host "          PACKAGE SUMMARY"
    Write-Host "========================================"
    Write-Host ""

    Write-Host ("Version      : {0}" -f $versionString)
    Write-Host ("Build        : {0}" -f $version.Build)
    Write-Host ("Branch       : {0}" -f $git.Branch)
    Write-Host ("Commit       : {0}" -f $git.Commit)
    Write-Host ("Package      : {0}" -f (Split-Path $zipFile -Leaf))
    Write-Host ("Output       : {0}" -f $packageRoot)

    if (Test-Path $zipFile) {

        $size = "{0:N2} MB" -f (
            (Get-Item $zipFile).Length / 1MB
        )

        Write-Host ("ZIP Size     : {0}" -f $size)

    }

    if ($packageLog) {

        Write-Host ("Log File     : {0}" -f $packageLog)

    }

    Write-Host ""
    Write-Host "PACKAGE CREATED SUCCESSFULLY" -ForegroundColor Green
    Write-Host "========================================"

    $packageSucceeded = $true

}
catch {

    Write-MonkError $_.Exception.Message

}
finally {

    if ($packageLog) {

        try {

            Stop-MonkReleaseLog | Out-Null

        }
        catch {
        }

    }

    if ($packageSucceeded) {

        Exit-MonkSuccess

    }
    else {

        Exit-MonkFailure "Package creation failed."

    }

}