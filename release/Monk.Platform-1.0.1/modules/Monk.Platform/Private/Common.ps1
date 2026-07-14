function Write-MonkInfo {
    param([string]$Message)
    Write-Host "[INFO ] $Message" -ForegroundColor Cyan
}

function Write-MonkSuccess {
    param([string]$Message)
    Write-Host "[ OK  ] $Message" -ForegroundColor Green
}

function Write-MonkWarning {
    param([string]$Message)
    Write-Host "[WARN ] $Message" -ForegroundColor Yellow
}

function Write-MonkError {
    param([string]$Message)
    Write-Host "[FAIL ] $Message" -ForegroundColor Red
}

function Test-MonkCommand {
    param(
        [Parameter(Mandatory)]
        [string]$Command
    )

    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Get-MonkRoot {

    $module = Get-Module Monk.Platform

    if ($module) {
        return Split-Path (Split-Path $module.ModuleBase -Parent) -Parent
    }

    return (Get-Location).Path
}

function Get-MonkTime {
    Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}
