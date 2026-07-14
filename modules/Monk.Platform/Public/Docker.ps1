function Get-MonkDockerStatus {

    [CmdletBinding()]
    param()

    if (-not (Test-MonkCommand docker)) {
        throw "Docker is not installed."
    }

    docker ps --format "{{.Names}}|{{.Status}}|{{.Image}}" |
    ForEach-Object {

        $parts = $_ -split "\|"

        [PSCustomObject]@{
            Name   = $parts[0]
            Status = $parts[1]
            Image  = $parts[2]
        }

    }

}

function Get-MonkContainer {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    docker ps -a --filter "name=$Name" --format "{{.Names}}"

}

function Start-MonkContainer {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    if ($PSCmdlet.ShouldProcess($Name, "Start container")) {

        Write-MonkLog "Starting container $Name"

        docker start $Name | Out-Null

    }

}

function Stop-MonkContainer {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    if ($PSCmdlet.ShouldProcess($Name, "Stop container")) {

        Write-MonkLog "Stopping container $Name"

        docker stop $Name | Out-Null

    }

}

function Restart-MonkContainer {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    if ($PSCmdlet.ShouldProcess($Name, "Restart container")) {

        Write-MonkLog "Restarting container $Name"

        docker restart $Name | Out-Null

    }

}

function Get-MonkContainerLogs {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [int]$Tail = 50
    )

    docker logs --tail $Tail $Name

}