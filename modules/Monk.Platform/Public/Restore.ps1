function Restore-MonkPlatform {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High'
    )]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $config = Get-MonkConfiguration

    $backup = Join-Path $config.Backups $Name

    if (!(Test-Path $backup)) {
        throw "Backup '$Name' not found."
    }

    if ($PSCmdlet.ShouldProcess($config.Root, "Restore backup '$Name'")) {

        Write-MonkLog "Restoring backup: $Name"

        $items = @(
            "platform.yaml",
            ".env",
            ".env.example",
            "docker-compose.yml",
            "configs",
            "docs",
            "templates"
        )

        foreach ($item in $items) {

            $source = Join-Path $backup $item

            if (Test-Path $source) {

                Copy-Item `
                    -Path $source `
                    -Destination $config.Root `
                    -Force `
                    -Recurse

            }

        }

        Send-MonkNotification `
            -Title "Backup" `
            -Message "Backup restored successfully." `
            -Level SUCCESS

    }

}

function Remove-MonkBackup {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High'
    )]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $config = Get-MonkConfiguration

    $backup = Join-Path $config.Backups $Name

    if (!(Test-Path $backup)) {
        throw "Backup '$Name' not found."
    }

    if ($PSCmdlet.ShouldProcess($backup, "Remove backup")) {

        Remove-Item `
            -Path $backup `
            -Recurse `
            -Force

        Write-MonkLog "Removed backup $Name"

    }

}