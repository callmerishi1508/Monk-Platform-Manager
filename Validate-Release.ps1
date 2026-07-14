$ErrorActionPreference = "Stop"

$validationLog = $null
$validationSucceeded = $false

try {

    #-------------------------------------------------------
    # Start Logging
    #-------------------------------------------------------

    $validationLog = Start-MonkReleaseLog

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
            Check  = $Name
            Passed = $Passed
        }

        if ($Passed) {

            Write-Host "✓ $Name"

        }
        else {

            Write-Host "✗ $Name"

        }

    }

    #-------------------------------------------------------
    # File Validation
    #-------------------------------------------------------

    Add-Check "version.json" `
        (Test-Path ".\version.json")

    Add-Check "Module Manifest" `
        (Test-Path ".\modules\Monk.Platform\Monk.Platform.psd1")

    Add-Check "Release Folder" `
        (Test-Path ".\release")

    #-------------------------------------------------------
    # Git Validation
    #-------------------------------------------------------

    $git = Get-MonkGitInfo

    Add-Check "Git Repository" $git.IsGitRepo

    if ($git.IsGitRepo) {

        Add-Check "Git Remote" ($git.Remote -ne "None")

        Add-Check "Current Branch" `
            (-not [string]::IsNullOrWhiteSpace($git.Branch))

        Add-Check "Current Commit" `
            ($git.Commit -ne "Unknown")

    }

    #-------------------------------------------------------
    # Final Validation
    #-------------------------------------------------------

    $failed = $checks | Where-Object Passed -eq $false

    Write-Host ""

    if ($failed) {

        Write-Host "RELEASE VALIDATION FAILED" `
            -ForegroundColor Red

        foreach ($item in $failed) {

            Write-Host (" - {0}" -f $item.Check)

        }

        throw "Release validation failed."

    }

    Write-Host "RELEASE VALIDATION PASSED" `
        -ForegroundColor Green

    $validationSucceeded = $true

}
catch {

    Write-MonkError $_.Exception.Message

}
finally {

    if ($validationLog) {

        try {

            Stop-MonkReleaseLog | Out-Null

        }
        catch {
        }

    }

    if ($validationSucceeded) {

        Exit-MonkSuccess

    }
    else {

        Exit-MonkFailure "Release validation failed."

    }

}