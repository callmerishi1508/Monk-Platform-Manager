$script:MonkContext = $null

function Get-MonkContext {

    if ($script:MonkContext) {
        return $script:MonkContext
    }

    $script:MonkContext = [PSCustomObject]@{

        Configuration = Get-MonkConfiguration

        Settings = Get-MonkSettings

        Services = Get-MonkServices

        Created = Get-Date

    }

    return $script:MonkContext

}

function Clear-MonkContext {

    $script:MonkContext = $null

}