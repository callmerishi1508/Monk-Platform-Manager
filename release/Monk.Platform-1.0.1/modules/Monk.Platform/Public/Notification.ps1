function Send-MonkNotification {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet(
            "INFO",
            "SUCCESS",
            "WARNING",
            "ERROR"
        )]
        [string]$Level = "INFO"

    )

    $config = Get-MonkNotificationSettings

    switch ($config.DefaultProvider) {

        "Console" {

            Write-MonkLog "$Title : $Message" -Level $Level

        }

        "Discord" {

            Send-MonkDiscordNotification `
                -Title $Title `
                -Message $Message `
                -Level $Level

        }

        "Slack" {

            Send-MonkSlackNotification `
                -Title $Title `
                -Message $Message `
                -Level $Level

        }

        "Teams" {

            Send-MonkTeamsNotification `
                -Title $Title `
                -Message $Message `
                -Level $Level

        }

        "Email" {

            Send-MonkEmailNotification `
                -Title $Title `
                -Message $Message `
                -Level $Level

        }

    }

}



function Send-MonkDiscordNotification {
    param($Title,$Message,$Level)
    Write-MonkLog "[Discord] $Title : $Message" $Level
}

function Send-MonkSlackNotification {
    param($Title,$Message,$Level)
    Write-MonkLog "[Slack] $Title : $Message" $Level
}

function Send-MonkTeamsNotification {
    param($Title,$Message,$Level)
    Write-MonkLog "[Teams] $Title : $Message" $Level
}

function Send-MonkEmailNotification {
    param($Title,$Message,$Level)
    Write-MonkLog "[Email] $Title : $Message" $Level
}