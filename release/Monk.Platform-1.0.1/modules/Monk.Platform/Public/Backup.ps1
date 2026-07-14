function Backup-MonkPlatform {

    [CmdletBinding()]
    param(
        [string]$Name = (Get-Date -Format "yyyy-MM-dd_HHmmss")
    )

    $config = Get-MonkConfiguration

    $backupRoot = Join-Path $config.Backups $Name

    if (!(Test-Path $backupRoot)) {
        New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    }

    Write-MonkLog "Creating backup: $Name"

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

        $source = Join-Path $config.Root $item

        if (Test-Path $source) {

            Copy-Item `
                -Path $source `
                -Destination $backupRoot `
                -Recurse `
                -Force

        }

    }

    @{
        Name      = $Name
        Timestamp = Get-Date
        Machine   = $env:COMPUTERNAME
        User      = $env:USERNAME
        Version   = "1.0.0"
    } |
    ConvertTo-Json |
    Set-Content (Join-Path $backupRoot "manifest.json")

	Get-ChildItem $backupRoot -Recurse -File |
	ForEach-Object {

	   [PSCustomObject]@{

        	File = $_.FullName.Replace("$backupRoot\", "")

        	SHA256 = (Get-FileHash $_.FullName -Algorithm SHA256).Hash

	    }

	} |
	ConvertTo-Json -Depth 5 |
	Set-Content (Join-Path $backupRoot "checksums.json")

    Send-MonkNotification `
    	-Title "Backup" `
    	-Message "Backup completed successfully." `
     	-Level SUCCESS

    Publish-MonkEvent `
    	-EventName "BackupCompleted" `
    	-Data @{
           Time = Get-Date
       }

}

function Get-MonkBackups {

    $config = Get-MonkConfiguration

    Get-ChildItem $config.Backups -Directory |
        Sort-Object LastWriteTime -Descending

}