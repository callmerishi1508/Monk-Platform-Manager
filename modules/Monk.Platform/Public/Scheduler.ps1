function Register-MonkTask {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param(

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Action,

        [Parameter(Mandatory)]
        [datetime]$Time

    )

    $taskAction = New-ScheduledTaskAction `
        -Execute "pwsh.exe" `
        -Argument "-Command `"Import-Module Monk.Platform; $Action`""

    $taskTrigger = New-ScheduledTaskTrigger `
        -Once `
        -At $Time

    if ($PSCmdlet.ShouldProcess($Name, "Register scheduled task")) {

        Register-ScheduledTask `
            -TaskName $Name `
            -Action $taskAction `
            -Trigger $taskTrigger `
            -Force

        Write-MonkSuccess "Task '$Name' registered."

    }

}

function Get-MonkTasks {

    [CmdletBinding()]
    param()

    Get-ScheduledTask |
        Where-Object TaskName -like "Monk*"

}

function Remove-MonkTask {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High'
    )]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    $task = Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue

    if (-not $task) {
        throw "Task '$Name' not found."
    }

    if ($PSCmdlet.ShouldProcess($Name, "Remove scheduled task")) {

        Unregister-ScheduledTask `
            -TaskName $Name `
            -Confirm:$false

        Write-MonkSuccess "Task '$Name' removed."

    }

}