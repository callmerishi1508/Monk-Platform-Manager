function Update-MonkContainers {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param()

    if ($PSCmdlet.ShouldProcess("Docker Containers", "Update")) {

        Write-MonkLog "Updating Docker containers"

        docker compose pull

        docker compose up -d

        Send-MonkNotification `
            -Title "Containers" `
            -Message "Docker containers updated successfully." `
            -Level SUCCESS

    }

}

function Update-MonkModule {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param()

    if ($PSCmdlet.ShouldProcess("Monk Platform Module", "Update")) {

        Write-MonkLog "Checking Monk Platform module"

        #
        # Future:
        # Install-Module / Update-Module
        #

        Send-MonkNotification `
            -Title "Module" `
            -Message "Monk Platform module is up to date." `
            -Level SUCCESS

    }

}

function Update-MonkPlatform {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High'
    )]
    param()

    if ($PSCmdlet.ShouldProcess("Monk AI Platform", "Update")) {

        Backup-MonkPlatform

        Update-MonkContainers

        Update-MonkModule

        Repair-MonkPlatform

        Send-MonkNotification `
            -Title "Platform" `
            -Message "Platform updated successfully." `
            -Level SUCCESS

        Publish-MonkEvent `
            -EventName "PlatformUpdated" `
            -Data @{
                Time = Get-Date
            }

    }

}