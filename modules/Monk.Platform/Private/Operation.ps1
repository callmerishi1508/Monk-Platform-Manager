function Invoke-MonkOperation {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [scriptblock]$Script
    )

    Write-MonkLog "$Name started"

    $start = Get-Date

    try {

        $result = & $Script

        [PSCustomObject]@{

            Success  = $true

            Operation = $Name

	    Started   = $start
	
	    Finished  = Get-Date

            Duration = ((Get-Date)-$start).TotalMilliseconds

            Result = $result

        }

    }
    catch {

        Write-MonkError $_

        [PSCustomObject]@{

            Success = $false

            Operation = $Name
	
	    Started   = $start

	    Finished  = Get-Date

            Duration = ((Get-Date)-$start).TotalMilliseconds

            Error = $_.Exception.Message

        }

    }

}