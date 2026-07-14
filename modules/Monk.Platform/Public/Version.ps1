function Get-MonkVersion {

    [CmdletBinding()]
    param()

    $version = Get-MonkVersionInfo

    "{0}.{1}.{2}" -f `
        $version.Major,
        $version.Minor,
        $version.Patch

}

function Set-MonkVersion {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [int]$Major,

        [Parameter(Mandatory)]
        [int]$Minor,

        [Parameter(Mandatory)]
        [int]$Patch

    )

    @{

        Major = $Major
        Minor = $Minor
        Patch = $Patch
        Prerelease = ""
        Build = 1

    } |
    ConvertTo-Json |
    Set-Content (Join-Path (Get-MonkRoot) "version.json")

}

function Increment-MonkVersion {

    [CmdletBinding()]
    param(

        [ValidateSet("Major","Minor","Patch")]
        [string]$Type = "Patch"

    )

    $versionFile = Join-Path (Get-MonkRoot) "version.json"

    $version = Get-Content $versionFile |
        ConvertFrom-Json

    switch($Type){

        "Major"{
            $version.Major++
            $version.Minor=0
            $version.Patch=0
        }

        "Minor"{
            $version.Minor++
            $version.Patch=0
        }

        "Patch"{
            $version.Patch++
        }

    }

    $version |
        ConvertTo-Json |
        Set-Content $versionFile

    Get-MonkVersion

}
