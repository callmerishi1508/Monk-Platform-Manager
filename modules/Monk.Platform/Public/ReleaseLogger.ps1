function Start-MonkReleaseLog {

    [CmdletBinding()]
    param()

    $logs = Join-Path (Get-MonkRoot) "logs"

    if (!(Test-Path $logs)) {

        New-Item `
            -ItemType Directory `
            -Force `
            -Path $logs | Out-Null

    }

    $file = Join-Path `
        $logs `
        ("release-{0}.log" -f (Get-Date -Format "yyyy-MM-dd_HH-mm-ss"))

    Start-Transcript `
        -Path $file `
        -Force | Out-Null

    return $file

}

function Stop-MonkReleaseLog {

    [CmdletBinding()]
    param()

    try {

        Stop-Transcript | Out-Null

    }
    catch {

    }

}
