function Invoke-MonkHealth {

    [CmdletBinding()]
    param()

    Write-MonkLog "Running health check"

    $results = @()

    $checks = @(
        @{ Name="PowerShell"; Test={ $PSVersionTable.PSVersion.Major -ge 7 } },
        @{ Name="Git"; Test={ Test-MonkCommand git } },
        @{ Name="GitHub CLI"; Test={ Test-MonkCommand gh } },
        @{ Name="Docker"; Test={ Test-MonkCommand docker } },
        @{ Name="Python"; Test={ Test-MonkCommand python } },
        @{ Name="Node"; Test={ Test-MonkCommand node } },
        @{ Name="npm"; Test={ Test-MonkCommand npm } }
    )

    foreach ($check in $checks) {

        $passed = & $check.Test

        $results += [PSCustomObject]@{
            Component = $check.Name
            Healthy   = [bool]$passed
        }

    }

    foreach ($service in Get-MonkServiceNames) {

        $status = Get-MonkServiceStatus $service

        $results += [PSCustomObject]@{
            Component = $service
            Healthy = ($status -eq "running")
        }

    }

    return $results
}