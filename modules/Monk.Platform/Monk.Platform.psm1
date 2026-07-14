Set-StrictMode -Version Latest

$ModuleRoot = Split-Path -Parent $PSCommandPath

# Load all private scripts
$privatePath = Join-Path $ModuleRoot "Private"
if (Test-Path $privatePath) {
    Get-ChildItem $privatePath -Filter *.ps1 |
        Sort-Object Name |
        ForEach-Object {
            . $_.FullName
        }
}

# Load all public scripts
$publicPath = Join-Path $ModuleRoot "Public"
if (Test-Path $publicPath) {
    Get-ChildItem $publicPath -Filter *.ps1 |
        Sort-Object Name |
        ForEach-Object {
            . $_.FullName
        }
}

# Export all functions defined in the Public folder
$exportedFunctions = foreach ($file in Get-ChildItem $publicPath -Filter *.ps1 -ErrorAction SilentlyContinue) {
    Select-String -Path $file.FullName -Pattern '^\s*function\s+([A-Za-z0-9_-]+)' |
        ForEach-Object { $_.Matches[0].Groups[1].Value }
}

if ($exportedFunctions) {
    Export-ModuleMember -Function $exportedFunctions
}

Import-MonkPlugins