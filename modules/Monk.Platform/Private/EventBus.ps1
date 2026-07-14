$script:MonkEventSubscribers = @{}

function Register-MonkEvent {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$EventName,

        [Parameter(Mandatory)]
        [scriptblock]$Action
    )

    if (-not $script:MonkEventSubscribers.ContainsKey($EventName)) {
        $script:MonkEventSubscribers[$EventName] = @()
    }

    $script:MonkEventSubscribers[$EventName] += $Action
}

function Publish-MonkEvent {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$EventName,

        [object]$Data
    )

    if (-not $script:MonkEventSubscribers.ContainsKey($EventName)) {
        return
    }

    foreach ($subscriber in $script:MonkEventSubscribers[$EventName]) {
        & $subscriber $Data
    }
}


Register-MonkEvent "PlatformUpdated" {

    param($data)

    Write-MonkLog "EVENT PlatformUpdated"

}

Register-MonkEvent "BackupCompleted" {

    param($data)

    Write-MonkLog "EVENT BackupCompleted"

}

Register-MonkEvent "RepairCompleted" {

    param($data)

    Write-MonkLog "EVENT RepairCompleted"

}