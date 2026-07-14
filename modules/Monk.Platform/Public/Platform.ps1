function Get-MonkPlatformStatus {

    [CmdletBinding()]
    param()

    foreach ($serviceName in Get-MonkServiceNames) {

        $status = Get-MonkServiceStatus $serviceName

        [PSCustomObject]@{
            Service = $serviceName
            Status  = $status
        }

    }

}

function Start-MonkPlatform {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param()

    if ($PSCmdlet.ShouldProcess("Monk AI Platform", "Start")) {

        Write-MonkLog "========== Starting Monk AI Platform =========="

        foreach ($serviceName in Get-MonkServiceNames) {

            $status = Get-MonkServiceStatus $serviceName

            if ($status -eq "running") {

                Write-MonkLog "$serviceName already running"

                continue

            }

            Start-MonkService $serviceName

        }

        Write-MonkLog "Platform startup completed." -Level SUCCESS

    }

}

function Stop-MonkPlatform {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param()

    if ($PSCmdlet.ShouldProcess("Monk AI Platform", "Stop")) {

        Write-MonkLog "========== Stopping Monk AI Platform =========="

        $services = Get-MonkServiceNames

        [array]::Reverse($services)

        foreach ($serviceName in $services) {

            $status = Get-MonkServiceStatus $serviceName

            if ($status -match "^Exited") {

                continue

            }

            Stop-MonkService $serviceName

        }

        Write-MonkLog "Platform shutdown completed." -Level SUCCESS

    }

}