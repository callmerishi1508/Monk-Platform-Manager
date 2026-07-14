$script:MonkSettings = $null

function Get-MonkSettings {

    if ($script:MonkSettings) {
        return $script:MonkSettings
    }

    $path = Join-Path $PSScriptRoot "..\Config\Defaults.json"

    $script:MonkSettings =
        Get-Content $path -Raw |
        ConvertFrom-Json

    return $script:MonkSettings

}

function Get-MonkSetting {

    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $settings = Get-MonkSettings

    $value = $settings

    foreach ($part in $Path.Split(".")) {

        $value = $value.$part

    }

    return $value

}

function Get-MonkNotificationSettings {

    $path = Join-Path $PSScriptRoot "..\Config\Notifications.json"

    Get-Content $path -Raw |
    ConvertFrom-Json

}