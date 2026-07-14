$script:MonkPlugins = @()

function Import-MonkPlugins {

    $root = Join-Path (Get-MonkRoot) "plugins"

    if (!(Test-Path $root)) {
        return
    }

    Get-ChildItem $root -Directory | ForEach-Object {

        $pluginFile = Join-Path $_.FullName "plugin.ps1"

        if (Test-Path $pluginFile) {

            . $pluginFile

            $script:MonkPlugins += $_.Name

            Write-MonkLog "Plugin loaded: $($_.Name)"

        }

    }

}
