function Exit-MonkSuccess {

    [CmdletBinding()]
    param()

    Write-MonkSuccess "Operation completed successfully."

    if (Test-MonkCI) {
        exit 0
    }

}

function Exit-MonkFailure {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message
    )

    Write-MonkError $Message

    if (Test-MonkCI) {
        exit 1
    }

    throw $Message

}

function Test-MonkCI {

    [CmdletBinding()]
    param()

    return (
        $env:CI -eq "true" -or
        $env:GITHUB_ACTIONS -eq "true" -or
        $env:TF_BUILD -eq "True"
    )

}
