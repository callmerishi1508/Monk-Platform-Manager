function Get-MonkVersionInfo {

    $versionFile = Join-Path (Get-MonkRoot) "version.json"

    if (!(Test-Path $versionFile)) {
        throw "version.json not found."
    }

    Get-Content $versionFile |
        ConvertFrom-Json

}
