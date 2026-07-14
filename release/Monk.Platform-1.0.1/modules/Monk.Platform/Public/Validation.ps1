function Test-MonkBackup {

    [CmdletBinding(DefaultParameterSetName="Latest")]
    param(

        [Parameter(ParameterSetName="Name")]
        [string]$Name,

        [Parameter(ParameterSetName="Latest")]
        [switch]$Latest

    )

    $config = Get-MonkConfiguration

    if ($PSCmdlet.ParameterSetName -eq "Latest") {
        $Name = (Get-MonkBackups | Select-Object -First 1).Name
    }

    $backup = Join-Path $config.Backups $Name

    if (!(Test-Path $backup)) {
        throw "Backup '$Name' not found."
    }

    $checksumFile = Join-Path $backup "checksums.json"

    if (!(Test-Path $checksumFile)) {
        throw "checksums.json not found."
    }

    $checksums = Get-Content $checksumFile -Raw | ConvertFrom-Json

    foreach ($entry in $checksums) {

        $file = Join-Path $backup $entry.File

        if (!(Test-Path $file)) {

            [PSCustomObject]@{
                File      = $entry.File
                Healthy   = $false
                Expected  = $entry.SHA256
                Actual    = "Missing"
            }

            continue
        }

        $actual = (Get-FileHash $file -Algorithm SHA256).Hash

        [PSCustomObject]@{
            File      = $entry.File
            Healthy   = ($actual -eq $entry.SHA256)
            Expected  = $entry.SHA256
            Actual    = $actual
        }

    }

}