function Get-MonkLogDirectory {
    $root = Get-MonkRoot
    $logDir = Join-Path $root "logs"

    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }

    return $logDir
}

function Write-MonkLog {

    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet("INFO","SUCCESS","WARNING","ERROR")]
        [string]$Level="INFO",

        [string]$LogFile="platform.log"
    )

    $timestamp = Get-MonkTime

    $line = "[$timestamp] [$Level] $Message"

    $path = Join-Path (Get-MonkLogDirectory) $LogFile

    Add-Content -Path $path -Value $line

    switch($Level){

        "INFO"    { Write-MonkInfo $Message }

        "SUCCESS" { Write-MonkSuccess $Message }

        "WARNING" { Write-MonkWarning $Message }

        "ERROR"   { Write-MonkError $Message }

    }

}