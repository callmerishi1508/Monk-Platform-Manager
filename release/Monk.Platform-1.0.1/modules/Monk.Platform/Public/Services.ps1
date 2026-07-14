function Get-MonkServices {

    $path = Join-Path $PSScriptRoot "..\Config\Services.json"

    $path = Resolve-Path $path

    Get-Content $path |
        ConvertFrom-Json

}

function Get-MonkService {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $services = Get-MonkServices

    return $services.$Name

}

function Get-MonkServiceNames {

    [CmdletBinding()]
    param()

    (Get-MonkServices).PSObject.Properties.Name

}

function Get-MonkServiceStatus {

    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $service = Get-MonkService $Name

    if (-not $service) {
        throw "Unknown service '$Name'"
    }

    try {

        docker inspect `
            --format "{{.State.Status}}" `
            $service.container

    }
    catch {

        "notfound"

    }

}

function Start-MonkService {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    if (Test-MonkStartedService $Name) {
        return
    }

    $service = Get-MonkService $Name

    if (-not $service) {
        throw "Unknown service '$Name'"
    }

    foreach ($dependency in $service.dependsOn) {

        Start-MonkService $dependency

    }

    $status = Get-MonkServiceStatus $Name

    if ($status -eq "running") {

        Add-MonkStartedService $Name
        return

    }

    if ($PSCmdlet.ShouldProcess($service.container, "Start service")) {

        Write-MonkLog "Starting $Name"

        docker start $service.container | Out-Null

        Add-MonkStartedService $Name

    }

}

function Stop-MonkService {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $service = Get-MonkService $Name

    if (-not $service) {
        throw "Unknown service '$Name'"
    }

    if ($PSCmdlet.ShouldProcess($service.container, "Stop service")) {

        Write-MonkLog "Stopping $Name"

        docker stop $service.container | Out-Null

    }

}

function Restart-MonkService {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    if ($PSCmdlet.ShouldProcess($Name, "Restart service")) {

        Stop-MonkService $Name

        Start-MonkService $Name

    }

}