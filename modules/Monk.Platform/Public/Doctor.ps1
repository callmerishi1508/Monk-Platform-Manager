function Invoke-MonkDoctor {

    [CmdletBinding()]
    param()

    Write-MonkLog "Running Monk Doctor"

    $issues = @()

    # Docker
    if (-not (Test-MonkCommand docker)) {
        $issues += [PSCustomObject]@{
            Component = "Docker"
            Status    = "FAIL"
            Problem   = "Docker CLI not installed."
            Fix       = "Install Docker Desktop."
        }
    }

    # Git
    if (-not (Test-MonkCommand git)) {
        $issues += [PSCustomObject]@{
            Component = "Git"
            Status    = "FAIL"
            Problem   = "Git not installed."
            Fix       = "Install Git for Windows."
        }
    }

    # GitHub CLI
    if (-not (Test-MonkCommand gh)) {
        $issues += [PSCustomObject]@{
            Component = "GitHub CLI"
            Status    = "WARN"
            Problem   = "GitHub CLI not installed."
            Fix       = "Install GitHub CLI."
        }
    }

    foreach ($service in Get-MonkServiceNames) {

        $status = Get-MonkServiceStatus $service

        if ($status -ne "running") {

            $issues += [PSCustomObject]@{
                Component = $service
                Status    = "FAIL"
                Problem   = "Container not running."
                Fix       = "Start-MonkService $service"
            }

        }

    }

    if ($issues.Count -eq 0) {

        Write-MonkSuccess "No issues detected."

        return

    }

    return $issues

}