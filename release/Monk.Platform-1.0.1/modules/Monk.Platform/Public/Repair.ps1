function Repair-MonkService {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    Invoke-MonkOperation "Repair $Name" {

        $status = Get-MonkServiceStatus $Name

        if ($status -eq "running") {

            Write-MonkSuccess "$Name is already healthy."

            Publish-MonkEvent `
                -EventName "RepairCompleted" `
                -Data @{
                    Service = $Name
                    Status  = "AlreadyHealthy"
                    Time    = Get-Date
                }

            return
        }

        Restart-MonkService $Name

        Start-Sleep -Seconds 2

        if ((Get-MonkServiceStatus $Name) -eq "running") {

            Write-MonkSuccess "$Name repaired successfully."

            Publish-MonkEvent `
                -EventName "RepairCompleted" `
                -Data @{
                    Service = $Name
                    Status  = "Repaired"
                    Time    = Get-Date
                }

        }
        else {

            throw "$Name repair failed."

        }

    }

}

function Repair-MonkPlatform {

    [CmdletBinding()]
    param()

    Invoke-MonkOperation "Repair Platform" {

        $ctx = Get-MonkContext

        foreach ($service in $ctx.Services) {

            Repair-MonkService $service.Name

        }

        Invoke-MonkDoctor

    }

}