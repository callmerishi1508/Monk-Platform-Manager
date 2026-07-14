function Invoke-MonkSafe {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$Operation,

        [Parameter(Mandatory)]
        [scriptblock]$Script

    )

    try {

        & $Script

    }
    catch {

        Write-MonkLog `
            "FAILED: $Operation - $($_.Exception.Message)" `
            -Level ERROR

        throw

    }

}
